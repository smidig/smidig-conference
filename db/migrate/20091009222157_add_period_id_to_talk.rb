class AddPeriodIdToTalk < ActiveRecord::Migration
  def self.up
    add_column :talks, :period_id, :integer
    Period.delete_all
    for scene_id in 0..2
      for time_id in 0..5
        Period.create :scene_id => scene_id, :time_id => time_id
      end
    end
  end

  def self.down
    remove_column :talks, :period_id
  end
end
