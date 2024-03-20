class TourAvailability < ApplicationRecord
  include ApplicationHelper
  include ActionView::Helpers::TextHelper

  attribute :recur_type, :integer
  enum recur_type: %i(daily weekly monthly yearly)
  enum recur_month: %i(exact_day nth_week)

  belongs_to :tour

  validates_presence_of :start_date, :tour_id
  validates_presence_of :recur_days, if: :weekly?
  validates_presence_of :recur_month, if: :monthly?
  validates :recur_type, inclusion: { in: recur_types.keys }, if: :recur_type?
  validates :recur_days, inclusion: { in: (0..6).to_a }, if: :weekly?
  validates :recur_month, inclusion: { in: recur_months.keys }, if: :monthly?
  validates :start_time, :end_time, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 2359 }, allow_nil: true
  validates :recur_frequency, numericality: { greater_than: 0 }, if: :recur_type?
  validate :rules
  before_save :clean_data

  def recur_days_to_arr
    recur_days.map { |e| Date::DAYNAMES[e] }
  end

  def recur_days_to_s
    recur_days_to_arr.join(", ")
  end

  def to_s
    if recur_type
      recur_str = recur_type.gsub("ly", '')
      recur_str = 'day' if recur_str == 'dai'

      str = "#{start_date < Date.today ? 'scheduled' : 'starts'} every"

      if recur_frequency == 1
        str << " #{recur_str}"
      else
        str << " #{pluralize(recur_frequency, recur_str)}"
      end

      if weekly?
        weekdays = (1..5).to_a
        weekends = [0, 6]

        if recur_days.count == 7
          str << " daily"
        elsif weekdays.count == recur_days.count && weekdays.all? { |e| recur_days.include?(e) }
          str << " on Weekdays"
        elsif weekends.count == recur_days.count && weekends.all? { |e| recur_days.include?(e) }
          str << " on Weekends"
        else
          str << " on #{recur_days_to_arr.map { |e| "#{e}s" }.join(', ')}"
        end
      elsif monthly?
        if nth_week?
          month_of_week = get_month_week(start_date)
          str << " on the #{month_of_week}#{month_of_week.ordinal} #{start_date.strftime("%A")}"
        else
          day = start_date.day
          str << " on the #{day}#{day.ordinal}"
        end
      elsif yearly?
        format = "%b %-d"
        str << " on #{[pretty_date_and_time(start_date, start_time, format), pretty_date_and_time(end_date, end_time || start_time, format)].compact.join(" to ")}"
      end

      if recur_end_date
        str << " ending on #{pretty_date(recur_end_date)}"
      elsif recur_end_occurrence
        str << " ending after #{pluralize(recur_end_occurrence, 'occurrence')}"
      end

    else
      str = start_date < Date.today ? 'started' : 'starts'
      str << " on #{[pretty_date_and_time(start_date, start_time), pretty_date_and_time(end_date, end_time || start_time)].compact.join(" to ")}"
    end

    str
  end

  def start_date_time
    str = pretty_date_and_time(start_date, start_time || 0)
    DateTime.parse(str) if str
  end

  def end_date_time
    str = pretty_date_and_time(end_date, end_time || start_time)
    DateTime.parse(str) if str
  end

  private

  def rules
    if start_date
      if end_date && end_date_time < start_date_time
        errors.add(:end_date, "should not be before start date.")
      end

      max_date = [start_date, end_date].compact.max
      if recur_end_date && recur_end_date < max_date
        errors.add(:recur_end_date, "should not be before #{max_date}.")
      end
    end

    [:start_time, :end_time].each do |time|
      val = send(time)
      if val && !valid_time?(val)
        errors.add(time, 'is not a valid time.')
      end
    end
  end

  def clean_data
    self.recur_days = [] unless weekly?
    self.recur_month = nil unless monthly?
    self.recur_end_occurrence = nil if recur_end_date

    unless recur_type
      self.recur_frequency = nil
      self.recur_end_date = nil
      self.recur_end_occurrence = nil
    end
  end
end
