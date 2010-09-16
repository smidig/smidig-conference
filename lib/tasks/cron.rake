require 'heroku_s3_backup'

task :cron => :environment do
  HerokuS3Backup.backup
end