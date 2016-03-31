class Time
  def prev_hour(hours)
    with_datetime(hours) { |datetime| datetime - (hours / 24.0) }
  end

  def prev_day(days)
    with_datetime(days) { |datetime| datetime.prev_day(days) }
  end

  def prev_month(months)
    with_datetime(months) { |datetime| datetime.prev_month(months) }
  end

  def prev_year(years)
    with_datetime(years) { |datetime| datetime.prev_year(years) }
  end

  private

  def with_datetime(period)
    return self unless period
    date_time = DateTime.parse(to_s)
    Time.parse(yield(date_time).to_s)
  end
end
