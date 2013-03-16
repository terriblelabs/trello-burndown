Airbrake.configure do |config|
  config.api_key     = ENV['AIRBRAKE_API_KEY']
  config.host        = ENV['AIRBRAKE_HOST'] if ENV['AIRBRAKE_HOST'].present?
  config.port        = 80
  config.secure      = config.port == 443
end if ENV['AIRBRAKE_API_KEY'].present?
