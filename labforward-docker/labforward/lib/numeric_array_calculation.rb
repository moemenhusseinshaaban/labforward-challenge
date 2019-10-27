class NumericArrayCalculation < Array
  APPROXIMATE_STANDARD_DEVIATION_MEAN_AD = 1.253314
  APPROXIMATE_STANDARD_DEVIATION_MEDIAN_AD = 1.486
  MOVING_Z_SCORE_IITIALIZE_LAG = 2

  class << self
    def z_score(score, array_mean, array_standerd_deviation)
      return 0 if array_standerd_deviation == 0
      (score - array_mean) / array_standerd_deviation
    end

    def signal(z_score, threshold)
      return 1 if z_score.abs.round > threshold
      0
    end

    def shift_element(array, old_mean, old_standard_deviation)
      size = array.size
      new_size = size - 1
      old_element = array.shift
      new_mean = ((old_mean * size) - old_element) / new_size
      new_standard_deviation = array.standerd_deviation(new_mean)
      [array, new_mean, new_standard_deviation]
    end

    def add_element(array, element, old_mean, old_standard_deviation)
      size = array.size
      new_size = size + 1
      array << element
      new_mean = ((old_mean * size) + element) / new_size
      new_standard_deviation = array.standerd_deviation(new_mean)
      [array, new_mean, new_standard_deviation]
    end
  end

  def mean
    sum / size.to_f
  end

  def standerd_deviation(array_mean)
    Math.sqrt(reduce(0.0) { |a, b| a.to_f + ((b.to_f - array_mean) ** 2) } / size.to_f)
  end

  def moving_z_score(threshold: 3)
    window =  (size / 3).to_i
    new_array = take(MOVING_Z_SCORE_IITIALIZE_LAG)
    result = Array.new(MOVING_Z_SCORE_IITIALIZE_LAG, 0)
    new_mean = new_array.mean
    new_stdv = new_array.standerd_deviation(new_mean)
    (MOVING_Z_SCORE_IITIALIZE_LAG..size-1).each do |index|
      if new_array.size > window
        new_array, new_mean, new_stdv = self.class.shift_element(new_array, new_mean, new_stdv)
      end
      z_score = self.class.z_score(self[index], new_mean, new_stdv)
      signal = self.class.signal(z_score, threshold)
      if signal == 0
        new_array, new_mean, new_stdv = self.class.add_element(new_array, self[index], new_mean, new_stdv)
      end
      result << signal
    end
    result
  end


  def modified_z_score(threshold: 3)
    array_median = median
    approximate_mad_calculation = modified_z_score_approximate_mad_calculation
    map do |val|
      z_score = (val - array_median) / approximate_mad_calculation
      z_score.abs > threshold ? 1 : 0
    end
  end

  def median
    sorted = sort
    len = sorted.length
    (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end

  %w[mean median].each do |calculation|
    define_method("#{calculation}_absolute_deviation") do
      array_calc = send(calculation)
      array = map do |val|
        (val - array_calc).abs
      end
      self.class.new(array).send(calculation)
    end
  end

  def modified_z_score_approximate_mad_calculation
    absolute_deviation = median_absolute_deviation
    approximate_standard_deviation = APPROXIMATE_STANDARD_DEVIATION_MEDIAN_AD
    if absolute_deviation == 0
      absolute_deviation = mean_absolute_deviation
      approximate_standard_deviation = APPROXIMATE_STANDARD_DEVIATION_MEAN_AD
    end
    (approximate_standard_deviation * absolute_deviation)
  end
end
