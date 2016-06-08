class Time
  def prev_hour(hours)
    with_datetime(hours.to_i) { |datetime| datetime - (hours.to_i / 24.0) }
  end

  def prev_day(days)
    with_datetime(days.to_i) { |datetime| datetime.prev_day(days.to_i) }
  end

  def prev_month(months)
    with_datetime(months.to_i) { |datetime| datetime.prev_month(months.to_i) }
  end

  def prev_year(years)
    with_datetime(years.to_i) { |datetime| datetime.prev_year(years.to_i) }
  end

  private

  def with_datetime(period)
    return self unless period
    date_time = DateTime.parse(to_s)
    Time.parse(yield(date_time).to_s)
  end
end
