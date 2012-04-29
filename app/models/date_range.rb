class DateRange
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :from, :to
  attr_accessor :from_date, :to_date

  DEFAULT_PERIOD = 12

  def initialize(params = nil)
    params ||= {}
    @to_date = params[:to] ? Chronic.parse(params[:to]) : Date.today 
    @from_date = params[:from] ? Chronic.parse(params[:from]) : DEFAULT_PERIOD.month.ago 
  end

  def persisted?
    false
  end

  def to_datetime
    @to_date.to_datetime.end_of_month
  end

  def to_date
    @to_date.to_date.end_of_month
  end

  def from_datetime
    @from_date.to_datetime.beginning_of_month
  end

  def from_date
    @from_date.to_date.beginning_of_month
  end

  def to
    @to ||= to_date.to_s(:month_and_year)
  end

  def from
    @from ||= from_date.to_s(:month_and_year)
  end

  def to_hash
    {date_range: { to: to, from: from } }
  end

  def list
    [].tap do |collection|
      (0..24).each do |month|
        collection << [month.month.ago.to_s(:month_and_year), month.month.ago.to_s(:month_and_year)]
      end
    end
  end
end
