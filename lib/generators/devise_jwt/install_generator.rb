module DeviseJwt
  class InstallGenerator < Rails::Generators::Base

    desc 'Creates a Devise JWT initializer and copy locale files to your application.'

    source_root File.expand_path('../templates', __FILE__)

    argument :resource_class, type: :string, default: 'User'

    def create_initializer_file
      copy_file 'initializers/devise_jwt.rb', 'config/initializers/devise_jwt.rb'
    end

    def copy_locale
      copy_file '../../../../config/locales/en.yml', 'config/locales/devise_jwt.en.yml'
    end
  end
end
