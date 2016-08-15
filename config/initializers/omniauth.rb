Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dataporten, 'CLIENT-ID', 'CLIENT-SECRET',
  redirect_url: 'http://127.0.0.1:3000'
end