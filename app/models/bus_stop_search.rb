class BusStopSearch
  include ActiveModel::Model
  
  attr_accessor :keyword

  validates :keyword, presence: true
  validate :bus_stop_exists

  def bus_stop_exists
    like = "%#{keyword}%"
    unless BusStop.where('name like ?', like).exists? then 
      errors.add(:keyword, "バス停が見つかりませんでした。")
    end 
  end 

end
