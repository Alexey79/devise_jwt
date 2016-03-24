module DeviseJwt
  class ControllersGenerator < Rails::Generators::Base

    desc <<-DESC.strip_heredoc
        Create inherited Devise controllers in your app/controllers folder.

        For example:

          rails generate devise_jwt:controllers admin

        This will create the controller classes at app/controllers/admin/ like this:

          class Admin::SessionsController < Devise::ConfirmationsController
            content...
          end
    DESC

    CONTROLLERS = %w(confirmations passwords registrations sessions refresh_token).freeze

    source_root File.expand_path('../templates/controllers', __FILE__)

    argument :scope, required: true

    def create_controllers
      @scope_prefix = scope.blank? ? '' : (scope.camelize + '::')
      CONTROLLERS.each do |name|
        template "#{name}_controller.rb", "app/controllers/#{scope}/#{name}_controller.rb"
      end
    end
  end
end
