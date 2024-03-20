class TourAvailability < ApplicationRecord
  attribute :recur_type, :integer
  enum recur_type: %i(daily weekly monthly yearly)
  enum recur_month: %i(exact_day nth_week)

  belongs_to :tour

  validates_presence_of :start_date

  def recur_days_to_s
    recur_days.map { |e| Date::DAYNAMES[e] }.join(", ")
  end
end
