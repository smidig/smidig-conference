# -*- encoding : utf-8 -*-
class TalkObserver < ActiveRecord::Observer
  def after_create(talk)
    # Twitter
    if Rails.env == 'experimental'
      cfg = YAML::load(Rails.root.join("tmp", "twitter.yml"))['production'].symbolize_keys
      puts "Auth: #{cfg[:username]} #{cfg[:password]}"
      auth = Twitter::HTTPAuth.new(username, password)
      base = Twitter::Base.new(auth)
      puts
      puts '###################################################'
      puts "Nytt lyntaleforslag: #{truncate(talk.title, 40, '...')}\" #{talk.path}"
      puts '###################################################'
      puts

      #base.update "Nytt lyntaleforslag: #{truncate(talk.title, 40, '...')}\" #{talk.path}"
    end
  end
end
