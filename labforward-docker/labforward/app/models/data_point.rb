class DataPoint < ApplicationRecord
  validates :point, presence: true

  scope :interval_data_points, -> (from, to) do
    where(created_at: from.beginning_of_day..to.end_of_day)
    .order(created_at: :asc)
    .pluck(:point)
  end
end
