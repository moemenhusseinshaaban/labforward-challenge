require 'rails_helper'

RSpec.describe DataPoint, type: :model do
  it { is_expected.to validate_presence_of(:point) }
end
