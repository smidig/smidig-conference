class AddMailSentToTalks < ActiveRecord::Migration
  def self.up
    add_column :talks, :email_sent, :boolean, :default => false
    Talk.all.each do |talk|
      if talk.acceptance_status == "accepted" || talk.acceptance_status == "refused" 
        talk.email_sent = true
        talk.save
      end
    end
   
  end

  def self.down
    remove_column :talks, :email_sent
  end
end
