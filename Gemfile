#Kjør ruby versjon 1.8.7 !
#gem install bundler

source :gemcutter
gem 'rails', '= 2.3.8'
gem 'paperclip', '~>2.3.4'
gem 'aws-s3', '~>0.6.2'

group :plugins do
  gem 'authlogic', '2.0.11'
  gem 'gchartrb'
  gem 'prawn', '= 0.6.3'
  gem 'prawnto'
end

group :development do
  gem 'faker'
  gem 'bullet'
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'taps'
end

group :test do
  gem 'mocha', :require => false #bug, need to be required at the bottom of test_helper
  gem 'shoulda'
  #gem 'factory_girl'
end

gem 'heroku_s3_backup' #db backup to S3