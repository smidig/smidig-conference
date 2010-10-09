#Kjør ruby versjon 1.8.7 !
#gem install bundler

source :gemcutter
gem 'rails', '= 2.3.8'
gem 'sqlite3-ruby', :require => 'sqlite3'

group :plugins do
  gem 'authlogic', '2.0.11'
  gem 'gchartrb'
end

group :development do
  gem 'faker'
  gem 'bullet'
end

group :test do
  gem 'mocha'
  gem 'shoulda'
  #gem 'factory_girl'
end

gem 'heroku_s3_backup' #db backup to S3