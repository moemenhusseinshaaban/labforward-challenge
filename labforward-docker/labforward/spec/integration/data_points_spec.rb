require 'swagger_helper'

describe 'Sudden Peaks API' do
  path '/api/data_points/sudden_peaks' do
    post 'Retrieves signals of zeros for normal points and ones for sudden peaks' do
      tags 'Data Points'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :measured_data, in: :body, schema: {
        type: :object,
        properties: {
          date_from: { type: :string, description: 'required format: YYYY-MM-DD' },
          date_to: { type: :string, description: 'required format: YYYY-MM-DD' },
          threshold: { type: :float, description: 'limits of normal points' }
        },
        required: %w[date_from date_to threshold']
      }

      response '200', 'Return Sudden Peaks of Data Points' do
        before(:each) do
          @today = Date.today
          @sample_data_points = [1.0, 1.1, 0.9, 1.0, 1.0, 1.2, 2.5, 2.3, 2.4, 1.1, 0.8, 1.2, 1.0]
          @first_day = Date.today - @sample_data_points.size + 1
          @sample_data_points.reverse.each_with_index do |point, index|
            FactoryBot.create(:data_point, point: point, created_at: (@today - index))
          end
        end

        it 'should handle the challenge example of returning the sudden peaks' do
          post sudden_peaks_path, params: {
                                    date_from: @first_day.strftime('%F'),
                                    date_to: @today.strftime('%F'),
                                    threshold: 3
                                  }
          expect(response).to have_http_status(:success)
          result = {
            "sample_data_points" => @sample_data_points,
            "signal" => [0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0]
          }
          expect(JSON.parse(response.body)).to eq(result)
        end
      end

      response '422', 'invalid record' do
        it 'should return 422 if date from greater than date to' do
          date_to =  Date.today
          date_from =  date_to + 1
          post sudden_peaks_path, params: {
                                    date_from: date_from.strftime('%F'),
                                    date_to: date_to.strftime('%F'),
                                    threshold: 3
                                  }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
