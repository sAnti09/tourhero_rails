module ApplicationHelper
  def options_for_enum(enum_types, selected = nil)
    options_for_select(enum_types.map { |key, _| [key.titleize, key] }, selected)
  end

  def pretty_date(date)
    date.strftime("%b %-d %Y")
  end

  def pretty_date_and_time(date, time)
    return nil unless date

    datetime = date
    format = "%b %-d %Y"

    if time
      hour, minute = time.divmod(100)
      datetime = datetime.to_time.change({ hour: hour, min: minute })
      format << " %l:%M%p "
    end
    datetime.strftime(format)
  end

  def get_month_week(date_or_time, start_day = :sunday)

    date = date_or_time.to_date
    week_start_format = start_day == :sunday ? '%U' : '%W'

    month_week_start = Date.new(date.year, date.month, 1)
    month_week_start_num = month_week_start.strftime(week_start_format).to_i
    month_week_start_num += 1 if month_week_start.wday > 4 # Skip first week if doesn't contain a Thursday

    month_week_index = date.strftime(week_start_format).to_i - month_week_start_num
    month_week_index + 1 # Add 1 so that first week is 1 and not 0

  end
end