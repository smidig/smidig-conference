def find_period(periods, scene, time)
  periods.find { |p| p.scene_id == scene && p.time_id == time }
end


TALKS_DIR = File.expand_path("~/Dropbox/Smidig2011/smidig2011-slides-production")

namespace :sort_slides do
  task :sort_slides => :environment do
	require 'fileutils'

	periods = Period.find(:all, :include => { :talks => :users })
	scenes = %w(Olympia Kunst Film)
	times = %w(nov14-09 nov14-10 nov14-11 nov15-09 nov15-10 nov15-11)
	
	(0..2).each do |scene|
		(0..5).each do |time|
			slot_dir = "#{TALKS_DIR}/#{scenes[scene]}/#{times[time]}"
			FileUtils.mkdir_p(slot_dir)
			period = find_period(periods, scene, time)
			for talk in period.talks
				FileUtils.mv Dir.glob("#{TALKS_DIR}/#{talk.id}-*"), slot_dir, 
					:noop => false, :verbose => false
			end
		end
	end
  end
end

