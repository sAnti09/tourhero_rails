require "test_helper"

class TourAvailabilityTest < ActiveSupport::TestCase
  setup do
    @tour = Tour.create(name: 'Sample Tour')
  end

  test "validates basic required fields" do
    availability = TourAvailability.new

    assert_not availability.save
    assert_includes availability.errors.full_messages_for(:tour_id).first, "blank"
    assert_includes availability.errors.full_messages_for(:start_date).first, "blank"
  end

  test "validates end_date" do
    availability = TourAvailability.new(tour: @tour, start_date: Date.today, end_date: Date.yesterday)

    assert_not availability.save
    assert_includes availability.errors.full_messages_for(:end_date).first, "before"

    availability.start_time = 1200
    availability.end_date = Date.today
    availability.end_time = 1159

    assert_not availability.save
    assert_includes availability.errors.full_messages_for(:end_date).first, "before"

    availability.end_time = 1201
    assert availability.save
  end

  test "validates time" do
    availability = TourAvailability.new(tour: @tour, start_date: Date.today, start_time: 1160, end_time: -1)

    assert_not availability.save
    assert_includes availability.errors.full_messages_for(:start_time).first, "not a valid time"
    assert_includes availability.errors.full_messages_for(:end_time).first, "greater than"

    availability.start_time = 1359
    availability.end_time = 2359
    assert availability.save
  end

  test "clears out recur data when not recurring" do
    availability = TourAvailability.new(
      tour: @tour,
      start_date: Date.today,
      start_time: 1150,
      recur_type: nil,
      recur_frequency: 5,
      recur_month: :exact_day,
      recur_days: [1, 2, 3],
      recur_end_date: Date.tomorrow,
      recur_end_occurrence: 5)

    assert availability.save

    nullable_columns = %i(recur_type recur_frequency recur_month recur_days recur_end_date recur_end_occurence)
    assert_empty availability.as_json(only: nullable_columns).values.flatten.compact
  end

  test "properly displays non-recurring schedule" do
    availability = TourAvailability.new(
      tour: @tour,
      start_date: Date.parse("March 5, 2050"),
      end_date: Date.parse("March 7, 2050"))

    assert availability.save
    assert_equal availability.to_s, "starts on Mar 5 2050 to Mar 7 2050"

    availability.start_date = Date.parse("March 5, 2024")
    assert_equal availability.to_s, "started on Mar 5 2024 to Mar 7 2050"
  end

  test "properly recurs daily" do
    availability = TourAvailability.new(
      tour: @tour,
      start_date: Date.today,
      recur_type: :daily,
      recur_frequency: 5)

    assert availability.save
    assert_equal availability.to_s, "starts every 5 days"

    nullable_columns = %i(recur_month recur_days)
    assert_empty availability.as_json(only: nullable_columns).values.flatten.compact

    availability.recur_frequency = 1
    assert_equal availability.to_s, "starts every day"

    availability.recur_frequency = 0
    assert_not availability.save
    assert_includes availability.errors.full_messages_for(:recur_frequency).first, "greater than"
  end

  test "properly recurs weekly" do
    availability = TourAvailability.new(
      tour: @tour,
      start_date: Date.today,
      recur_type: :weekly,
      recur_frequency: 5,
      recur_days: [0, 2])

    assert availability.save
    assert_equal availability.to_s, "starts every 5 weeks on Sundays, Tuesdays"

    availability.recur_frequency = 1
    assert_equal availability.to_s, "starts every week on Sundays, Tuesdays"

    availability.recur_days = [0, 6]
    assert_equal availability.to_s, "starts every week on Weekends"

    availability.recur_days = (1..5).to_a
    assert_equal availability.to_s, "starts every week on Weekdays"

    availability.recur_days = (0..6).to_a
    assert_equal availability.to_s, "starts every week daily"

    availability.recur_days = [0, 1, 6]
    assert_equal availability.to_s, "starts every week on Sundays, Mondays, Saturdays"

    availability.recur_days = [7]
    assert_not availability.save
    assert_includes availability.errors.full_messages_for(:recur_days).first, "not included in the list"

    availability.recur_frequency = 0
    availability.recur_days = []
    assert_not availability.save
    assert_includes availability.errors.full_messages_for(:recur_frequency).first, "greater than"
    assert_includes availability.errors.full_messages_for(:recur_days).first, "blank"
  end

  test "properly recurs monthly" do
    availability = TourAvailability.new(
      tour: @tour,
      start_date: Date.parse("March 15, 2024"),
      recur_type: :monthly,
      recur_frequency: 5,
      recur_month: :exact_day)

    assert availability
    assert_equal availability.to_s, "scheduled every 5 months on the 15th"

    availability.start_date = Date.parse("March 15, 2050")
    availability.recur_frequency = 1
    assert_equal availability.to_s, "starts every month on the 15th"

    availability.start_date = Date.parse("February 29, 2024")
    availability.recur_month = :nth_week
    assert_equal availability.to_s, "scheduled every month on the 5th Thursday"

    assert_raises ArgumentError do
      availability.recur_month = :hello
    end

    availability.recur_frequency = 0
    availability.recur_month = nil
    assert_not availability.save
    assert_includes availability.errors.full_messages_for(:recur_frequency).first, "greater than"
    assert_includes availability.errors.full_messages_for(:recur_month).first, "blank"
  end

  test "properly recurs yearly" do
    availability = TourAvailability.new(
      tour: @tour,
      start_date: Date.parse("March 15, 2024"),
      recur_type: :yearly,
      recur_frequency: 5,)

    assert availability
    assert_equal availability.to_s, "scheduled every 5 years on Mar 15"

    availability.start_date = Date.parse("March 15, 2050")
    availability.recur_frequency = 1
    assert_equal availability.to_s, "starts every year on Mar 15"

    availability.recur_frequency = 0
    assert_not availability.save
    assert_includes availability.errors.full_messages_for(:recur_frequency).first, "greater than"
  end
end
