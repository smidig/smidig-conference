if Rails.env.production?
  ENV['INFO_APP_BASE'] = 'http://smidig2012.no'	
else 
  ENV['INFO_APP_BASE'] = 'http://localhost:3001'
end