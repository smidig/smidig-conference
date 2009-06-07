class Array
  def shuffle
    sort_by { rand }
  end

  def shuffle!
    self.replace shuffle
  end
end


namespace :db do
  desc "Erase and fill database"
  task :populate => :migrate do
    require 'populator'
    require 'faker'
    
    [MessageDelivery, Message, Period, Registration, Comment, Vote, Talk, User, Topic].each(&:delete_all)
    
    User.populate 300..550 do |user|
      user.email   = Faker::Internet.email
      user.name    = Faker::Name.name
      user.company = Faker::Company.name
      user.phone_number = Faker::PhoneNumber.phone_number
      user.billing_address = Faker::Address.secondary_address
      user.created_at = Populator.value_in_range 3.months.ago..Time.now
      user.persistence_token = Faker::Lorem.words(1).to_s.capitalize
      user.crypted_password = Faker::Lorem.words(1).to_s.capitalize 
      user.password_salt = Faker::Lorem.words(1).to_s.capitalize
      user.login_count = rand(100)
      user.failed_login_count = rand(3)
    end
    # For some reason, the User model has stopped accepting
    #  the attributes that are nested from acts_as_authentic.
    #  (email, password, password_confirmation)
    # Each of these could be a oneliner if we fixed this.
    u = User.create :name => "Foo", :company => "Foo Bar Corp"
    u.email = 'test@test.com'
    u.password = 'password'
    u.password_confirmation = 'password'
    u.save!
    u = User.create :name => "Bar", :company => "Bar Corp"
    u.email = 'bar@test.com'
    u.password = 'password'
    u.password_confirmation = 'password'
    u.save!
    u = User.create :name => "Smidig Admin", :company => "Smidig 2009", :is_admin => true
    u.email = 'admin@smidig.no'
    u.password = 'password'
    u.password_confirmation = 'password'
    u.save!
    
    user_ids = User.find(:all).collect { |u| u.id }
        
    Topic.populate 20 do |topic|
      topic.title = Populator.words(1..3).titleize
      topic.description = Populator.paragraphs(1..5)
      Talk.populate 0..20 do |talk|
        talk.topic_id = topic.id
        talk.title = Populator.words(1..5).titleize
        talk.description = Populator.paragraphs(1..5)
        talk.speaker_id = user_ids.rand
        talk.video_url = "d2t2p02" if rand > 0.5
        talk.slideshare_url = "20080910-javazone-brodwall-continuous-deployment-1222324585598609-9" if rand > 0.5
        talk.created_at = Populator.value_in_range 3.months.ago..Time.now
        talk.votes_count = 0
        talk.allow_derivatives = ['', 'nd', 'sa'].rand
        talk.allow_commercial_use = [true,false].rand
        
        Comment.populate 0..5 do |comment|
          comment.talk_id = talk.id
          comment.title = Populator.words(1..5).titleize
          comment.description = Populator.paragraphs(1..5)
          comment.user_id = user_ids.rand
          comment.created_at = Populator.value_in_range talk.created_at..Time.now
        end
      end
    end
    
    topic_ids = Topic.find(:all).collect { |t| t.id }
    topic_ids.shuffle!
    
    for time_id in 0..6
      for scene_id in 0..2
        Period.create(:topic_id => topic_ids.pop, :scene_id => scene_id, :time_id => time_id, :topic_offset => 0)
      end
    end
  end
end