class Time
  class << self

    def subtract_period(time, options)
      return time unless options

      hours = options[:hours]
      days = options[:days]
      months = options[:months]

      subtracted_time = time
      subtracted_time = subtracted_time - hours_to_seconds(hours.to_i) if hours
      subtracted_time = subtracted_time - days_to_seconds(days.to_i) if days
      subtracted_time = (subtracted_time.to_datetime << months.to_i).to_time if months
      subtracted_time
    end

    private

    def days_to_seconds(days)
      hours_to_seconds(24) * days
    end

    def hours_to_seconds(hours)
      60 * 60 * hours
    end

  end

end