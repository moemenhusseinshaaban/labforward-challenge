class DataPointsController < ApplicationController
  before_action :apply_parameters, only: :sudden_peaks
  before_action :validate_parameters, only: :sudden_peaks

  def sudden_peaks
    sample_data_points = DataPoint.interval_data_points(@date_from, @date_to)
    signal = NumericArrayCalculation.new(sample_data_points).moving_z_score(threshold: @threshold)
    result = {
      sample_data_points: sample_data_points,
      signal: signal
    }
    render_200(result)
  end

  private

  def apply_parameters
    @date_from = Date.parse(params[:date_from])
    @date_to = Date.parse(params[:date_to])
    @threshold = params[:threshold].to_f
  end

  def validate_parameters
    (render_422('Invalid Record') && return) if @date_from > @date_to
  end
end
