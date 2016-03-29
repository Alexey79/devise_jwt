class DeviseJwtController < DeviseController
  respond_to :json

  def resource_data
    self.resource.to_json
  end

  def resource_errors
    self.resource.errors.to_hash(true).map do |k, v|
      v.map { |msg| {id: k, message: msg} }
    end.flatten
  end
end
