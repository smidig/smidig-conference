def find_period(periods, scene, time)
  periods.find { |p| p.scene_id == scene && p.time_id == time }
end


TALKS_DIR = File.expand_path("~/Documents/My Dropbox/Smidig2010/Lyntaler")

namespace :sort_slides do
  task :sort_slides => :environment do
	require 'ftools'

	periods = Period.find(:all, :include => { :talks => :users })
	scenes = %w(Helsingforssalen Stockholmsalen Oslosalen)
	times = %w(nov16-09 nov16-10 nov16-11 nov17-09 nov17-10 nov17-11)
	
	(0..2).each do |scene|
		(0..5).each do |time|
			slot_dir = "#{TALKS_DIR}/#{scenes[scene]}/#{times[time]}"
			File.makedirs(slot_dir)
			
			period = find_period(periods, scene, time)
			for talk in period.talks
				FileUtils.mv Dir.glob("#{TALKS_DIR}/#{talk.id}-*"), slot_dir, 
					:noop => false, :verbose => false
			end
		end
	end
  end
end

