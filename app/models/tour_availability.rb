class TourAvailability < ApplicationRecord
  attribute :recur_type, :integer
  enum recur_type: %i(daily weekly monthly yearly)
  enum recur_month: %i(exact_day nth_week)

  belongs_to :tour

  validates_presence_of :start_date
  validates_presence_of :recur_days, if: :weekly?
  validates :recur_type, inclusion: { in: recur_types.keys }, if: :recur_type?
  validates :recur_month, inclusion: { in: recur_months.keys }, if: :monthly?
  validate :rules
  before_save :clean_data

  def recur_days_to_s
    recur_days.map { |e| Date::DAYNAMES[e] }.join(", ")
  end

  private

  def rules
    if start_date
      max_date = [start_date, end_date].compact.max

      if end_date && end_date < start_date
        errors.add(:end_date, "should not be before #{start_date}.")
      end
      if recur_end_date && recur_end_date < max_date
        errors.add(:recur_end_date, "should not be before #{max_date}.")
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
