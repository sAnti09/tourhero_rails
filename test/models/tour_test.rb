require "test_helper"

class TourTest < ActiveSupport::TestCase
  test "requires name" do
    tour = Tour.new
    assert_not tour.save
    assert_includes tour.errors.full_messages_for(:name).first, "blank"
  end

  test "saves successfully" do
    tour = Tour.new(name: 'sample')
    assert tour.save
  end
end
