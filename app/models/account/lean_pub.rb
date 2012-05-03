class Account::LeanPub < Account
  SALE_ID, PAID, ROYALTY, DATE = *(0..3)

  def synch
    start_web_session
    import_books
    import_sales
  end

  def start_web_session
    page  = agent.get('http://leanpub.com/sign_in')

    form = page.form_with(:action => '/session')
    form['session[email]'] = login
    form['session[password]'] = password
    form.submit
  end

  private

  def agent
    @agent ||= Mechanize.new
  end

  def import_books
    page = agent.get('http://leanpub.com/dashboard')
    page.search(".row .well strong a").each do |link|
      book = Book.create!(title: link.text)
      account_books.create(book: book, lean_pub_link: link.attr('href'))
    end
  end

  def import_sales
    account_books.each do |leanpub_book|
      page = agent.get("http://leanpub.com#{leanpub_book.lean_pub_link}/sales")
      page.search("//table/thead/tr/th[contains(., 'Purchase ID')]/../../../tbody/tr").each do |row|
        royalties = row.element_children[ROYALTY].content.to_money
        sale_date = row.element_children[DATE].content
        date = Date.parse(row.element_children[DATE].content)

        leanpub_book
          .book
          .sales
          .create!(units: 1, amount: royalties.cents, currency: royalties.currency.iso_code, date_of_sale: date)
      end
    end
  end
end
