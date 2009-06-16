if RAILS_ENV != 'test'
  cfg = YAML::load(File.open("#{RAILS_ROOT}/config/email.yml"))
  ActionMailer::Base.smtp_settings = cfg[RAILS_ENV] unless cfg[RAILS_ENV].nil?
end
