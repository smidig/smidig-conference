gem "rake", "0.9.2"
source :gemcutter
gem 'rails', '= 3.0.7'
gem 'paperclip', '~>2.3.4'
gem 'aws-s3', :require=>'aws/s3'

gem 'authlogic', :git => 'git://github.com/odorcicd/authlogic.git', :branch => 'rails3'
gem 'gchartrb'
gem 'prawn', '= 0.6.3'
gem 'prawnto'

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
