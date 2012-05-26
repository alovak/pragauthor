class Account::LeanPub < Account
  SALE_ID, PAID, ROYALTY, _, DATE = *(0..4)

  after_create :sync
  after_update :sync

  def sync
    begin
      start_web_session
      import_books
      import_sales
    rescue => e
      ExceptionNotifier::Notifier
        .background_exception_notification(e, :data => { account: self, user: user })
    end
  end

  def start_web_session
    page  = agent.get('http://leanpub.com/sign_in')

    form = page.form_with(:action => '/session')
    form['session[email]'] = login
    form['session[password]'] = password
    form.submit
  end

  private

  def import_books
    page = agent.get('http://leanpub.com/dashboard')
    page.search(".row .well strong a.book-link").each do |link|
      create_book(link.text, link.attr('href'))
    end
  end

  def create_book(title, link)
    if can_be_imported?(title)
      book = user.books.find_or_create_by_title(title: title)

      unless account_books.find_by_book_id(book.id)
        account_books.create(book: book, lean_pub_link: link)
      end
    end
  end

  def can_be_imported?(link)
    # book in stelth mode
    link !~ /\/edit$/
  end

  def import_sales
    account_books.each do |leanpub_book|
      page = agent.get("http://leanpub.com#{leanpub_book.lean_pub_link}/sales")
      page.search("//table/thead/tr/th[contains(., 'Purchase ID')]/../../../tbody/tr").each do |row|
        royalties = row.element_children[ROYALTY].content.to_money
        sale_date = row.element_children[DATE].content
        date = Chronic.parse(row.element_children[DATE].content)

        unless leanpub_book.sales.where(:purchase_id => row.element_children[SALE_ID].content).any?
          leanpub_book.book.sales.create!(
            units: 1,
            amount: royalties.cents,
            purchase_id: row.element_children[SALE_ID].content,
            currency: royalties.currency.iso_code,
            date_of_sale: date,
            vendor: vendor
          )
        end
      end
    end
  end

  def vendor
    @vendor ||= Vendor.find_by_name('LeanPub')
  end

  def agent
    @agent ||= Mechanize.new
  end
end
