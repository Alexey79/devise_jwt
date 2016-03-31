module DeviseJwt
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration if block_given?
    end
  end

  class Configuration
    attr_accessor :secret_key
    attr_accessor :secret_key_path
    attr_accessor :algorithm
    attr_accessor :expiration_time

    def initialize
      @secret_key = nil
      @secret_key_path = nil
      @algorithm = :HS512
      @expiration_time = 0.hours
    end
  end
end