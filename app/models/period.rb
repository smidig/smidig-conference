class Period < ActiveRecord::Base
  has_many :talks, :order => 'position'
  
  def talk_list
    result = Array.new(4)
    for talk in talks
      result[talk.position] = talk if (0..3).include? talk.position
    end
    result
  end
  
end
