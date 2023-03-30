class ErrorSerializer
  include JSONAPI::Serializer
  def self.serialize_error(exception, status, message)
    {message: message, errors: [detail: exception.message, status: status]}
  end
end
