json.extract! tour_availability, :id, :start_date, :start_time, :end_date, :end_time, :recur_type, :recur_frequency, :recur_days, :recur_month, :recur_end_date, :recur_end_occurrence, :created_at, :updated_at
json.url tour_availability_url(tour_availability, format: :json)
