module ApplicationHelper
  def options_for_enum(enum_types, selected = nil)
    options_for_select(enum_types.map { |key, _| [key.titleize, key] }, selected)
  end

  def pretty_date(date)
    pretty_date_and_time(date, nil)
  end

  def pretty_date_and_time(date, time, format = "%b %-d %Y")
    return nil unless date

    datetime = date

    if time
      hour, minute = time.divmod(100)
      datetime = datetime.to_time.change({ hour: hour, min: minute })
      format << " %l:%M%p "
    end
    datetime.strftime(format)
  end

  def get_month_week(date_or_time)
    date_or_time.cweek - date_or_time.beginning_of_month.cweek + 1
  end

  def valid_time?(time)
    hour, minute = time.divmod(100)
    hour < 24 && minute < 60
  end
end