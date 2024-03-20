class Tour < ApplicationRecord
  has_many :tour_availabilities

  validates_presence_of :name
end
