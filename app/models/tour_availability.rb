class TourAvailability < ApplicationRecord
  attribute :recur_type, :integer
  attribute :recur_month, :integer

  enum recur_type: %i(daily weekly monthly yearly)
  enum recur_month: %i(exact_day, nth_day)
end
