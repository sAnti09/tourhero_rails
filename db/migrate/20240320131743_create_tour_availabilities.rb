class CreateTourAvailabilities < ActiveRecord::Migration[7.1]
  def change
    create_table :tour_availabilities do |t|
      t.date :start_date
      t.integer :start_time
      t.date :end_date
      t.integer :end_time
      t.integer :recur_type
      t.integer :recur_frequency
      t.integer :recur_days, array: true, default: []
      t.integer :recur_month
      t.date :recur_end_date
      t.integer :recur_end_occurrence

      t.timestamps
    end
  end
end
