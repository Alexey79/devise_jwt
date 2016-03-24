module ActionDispatch::Routing
  class Mapper
    def devise_jwt_for(resource, options)

      options[:controllers] ||= {}
      options[:defaults] ||= {}
      options[:failure_app] ||= {}

      controllers = {}
      %w(sessions registrations passwords confirmations).each do | name |
        controllers[name.to_sym] = options[:controllers][name.to_sym] || "devise_jwt/#{name}"
      end

      devise_for resource,
                 :class_name => resource.to_s.classify,
                 :module => :devise,
                 :controllers => controllers,
                 :defaults => options[:defaults],
                 :failure_app => options[:failure_app]

    end
  end
end