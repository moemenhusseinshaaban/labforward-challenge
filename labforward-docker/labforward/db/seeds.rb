# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if DataPoint.count == 0
  initialize_message = "Inprogress applying seeds from excel sheet with starting date from #{Date.today} to previous per each point"
  success_message = "Seeds successfully added"
  Rails.logger.info initialize_message
  p initialize_message
  points = [
    1, 2, 1, 0, 1, 2, 1, 8, 9, 8, 1, 2, 0, 2, 1, 2, 3, 1, 2,
    0, 8, 9, 2, 0, 3, 0, 2, 1, 2, 3, 8, 10, 2, 1, 2, 3, 0, 1,
    2, 1, 2, 7, 6, 9, 1, 2, 0, 1, 2, 1, 0, 2, 1, 2, 3, 10, 12,
    1, 1, 2, 3, 0, 1, 2, 1, 2, 7, 6, 9, 1, 2, 0, 1, 2, 1, 2, 1,
    3, 0, 2, 3, 1, 1, 2, 3, 10, 9, 12, 0, 2, 3, 1, 2, 0, 1, 7,
    11, 0, 1, 2, 2, 1, 3, 0, 2, 2, 9, 7, 2, 3, 1, 2, 9, 8, 2,
    3, 1, 2, 0, 1, 2, 3, 0, 10, 9, 1, 2, 1, 0, 1, 2, 1, 8, 9,
    8, 1, 2, 0, 2, 1, 2, 1, 14, 10, 0, 1, 1, 2, 0, 3
  ]
  points.each_with_index do |point, index|
    DataPoint.create(point: point, created_at: (Date.today - index))
  end
  Rails.logger.info success_message
  p success_message
  starting_date = (Date.today - (points.size - 1)).strftime('%F')
  starting_date_message = "Starting Date: #{starting_date}"
  Rails.logger.info starting_date_message
  p starting_date_message
  ending_date_message = "Ending Date: #{Date.today.strftime('%F')}"
  Rails.logger.info ending_date_message
  p ending_date_message
end
