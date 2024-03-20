require "application_system_test_case"

class TourAvailabilitiesTest < ApplicationSystemTestCase
  setup do
    @tour_availability = tour_availabilities(:one)
  end

  test "visiting the index" do
    visit tour_availabilities_url
    assert_selector "h1", text: "Tour availabilities"
  end

  test "should create tour availability" do
    visit tour_availabilities_url
    click_on "New tour availability"

    fill_in "End date", with: @tour_availability.end_date
    fill_in "End time", with: @tour_availability.end_time
    fill_in "Recur days", with: @tour_availability.recur_days
    fill_in "Recur end date", with: @tour_availability.recur_end_date
    fill_in "Recur end occurrence", with: @tour_availability.recur_end_occurrence
    fill_in "Recur frequency", with: @tour_availability.recur_frequency
    fill_in "Recur month", with: @tour_availability.recur_month
    fill_in "Recur type", with: @tour_availability.recur_type
    fill_in "Start date", with: @tour_availability.start_date
    fill_in "Start time", with: @tour_availability.start_time
    click_on "Create Tour availability"

    assert_text "Tour availability was successfully created"
    click_on "Back"
  end

  test "should update Tour availability" do
    visit tour_availability_url(@tour_availability)
    click_on "Edit this tour availability", match: :first

    fill_in "End date", with: @tour_availability.end_date
    fill_in "End time", with: @tour_availability.end_time
    fill_in "Recur days", with: @tour_availability.recur_days
    fill_in "Recur end date", with: @tour_availability.recur_end_date
    fill_in "Recur end occurrence", with: @tour_availability.recur_end_occurrence
    fill_in "Recur frequency", with: @tour_availability.recur_frequency
    fill_in "Recur month", with: @tour_availability.recur_month
    fill_in "Recur type", with: @tour_availability.recur_type
    fill_in "Start date", with: @tour_availability.start_date
    fill_in "Start time", with: @tour_availability.start_time
    click_on "Update Tour availability"

    assert_text "Tour availability was successfully updated"
    click_on "Back"
  end

  test "should destroy Tour availability" do
    visit tour_availability_url(@tour_availability)
    click_on "Destroy this tour availability", match: :first

    assert_text "Tour availability was successfully destroyed"
  end
end
