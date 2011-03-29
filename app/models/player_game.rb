class PlayerGame < ActiveRecord::Base
  belongs_to :player
  belongs_to :game
  belongs_to :winner_type
  
  validates_numericality_of :matchup_rate , :allow_nil => true, :less_than_or_equal_to => 99
  validates_numericality_of :matchup_time , :allow_nil => true, :less_than_or_equal_to => 99
  validates_numericality_of :real_rate , :allow_nil => true, :less_than_or_equal_to => 99
  validates_numericality_of :real_time , :allow_nil => true, :less_than_or_equal_to => 99
  
  def self.fron_score_value(score)
    if score
      result = 7 if score >= 35
      result = 6 if score >= 30 && score < 35
      result = 5 if score >= 25 && score < 30
      result = 4 if score >= 20 && score < 25
      result = 3 if score >= 15 && score < 20
      result = 2 if score >= 10 && score < 15
      result = 1 if score >= 5 && score < 10
      result = 0 if score < 5
      result
    else
      0
    end
  end
  
  def get_front_rate(type)
    result = PlayerGame.fron_score_value(matchup_rate) if type == :matchup
    result = PlayerGame.fron_score_value(real_rate) if type == :review
    result
  end

  end