OmniAuth.config.logger = Rails.logger
Rails.application.config.middleware.use OmniAuth::Builder do
 provider :facebook, Rails.application.secrets.facebook_app_id, Rails.application.secrets.facebook_app_secret, 
 scope: 'email', info_fields: 'id,first_name,last_name,email'
end