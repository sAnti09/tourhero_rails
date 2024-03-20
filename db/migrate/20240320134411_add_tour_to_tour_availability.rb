class AddTourToTourAvailability < ActiveRecord::Migration[7.1]
  def change
    add_reference :tour_availabilities, :tour
  end
end
