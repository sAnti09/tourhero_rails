require "test_helper"

class TourAvailabilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tour_availability = tour_availabilities(:one)
  end

  test "should get index" do
    get tour_availabilities_url
    assert_response :success
  end

  test "should get new" do
    get new_tour_availability_url
    assert_response :success
  end

  test "should create tour_availability" do
    assert_difference("TourAvailability.count") do
      post tour_availabilities_url, params: { tour_availability: { end_date: @tour_availability.end_date, end_time: @tour_availability.end_time, recur_days: @tour_availability.recur_days, recur_end_date: @tour_availability.recur_end_date, recur_end_occurrence: @tour_availability.recur_end_occurrence, recur_frequency: @tour_availability.recur_frequency, recur_month: @tour_availability.recur_month, recur_type: @tour_availability.recur_type, start_date: @tour_availability.start_date, start_time: @tour_availability.start_time } }
    end

    assert_redirected_to tour_availability_url(TourAvailability.last)
  end

  test "should show tour_availability" do
    get tour_availability_url(@tour_availability)
    assert_response :success
  end

  test "should get edit" do
    get edit_tour_availability_url(@tour_availability)
    assert_response :success
  end

  test "should update tour_availability" do
    patch tour_availability_url(@tour_availability), params: { tour_availability: { end_date: @tour_availability.end_date, end_time: @tour_availability.end_time, recur_days: @tour_availability.recur_days, recur_end_date: @tour_availability.recur_end_date, recur_end_occurrence: @tour_availability.recur_end_occurrence, recur_frequency: @tour_availability.recur_frequency, recur_month: @tour_availability.recur_month, recur_type: @tour_availability.recur_type, start_date: @tour_availability.start_date, start_time: @tour_availability.start_time } }
    assert_redirected_to tour_availability_url(@tour_availability)
  end

  test "should destroy tour_availability" do
    assert_difference("TourAvailability.count", -1) do
      delete tour_availability_url(@tour_availability)
    end

    assert_redirected_to tour_availabilities_url
  end
end
