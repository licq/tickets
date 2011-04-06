class City < ActiveRecord::Base
  validates :name, :presence => true
  validates :code, :presence => true
  validates :pinyin, :presence => true

  has_and_belongs_to_many :spots

  def self.search(word)
#    where("name LIKE :word OR pinyin LIKE :word", :word => "#{word}%")
    where(:name.matches % "#{word}%" | :pinyin.matches % "#{word}%")
  end
end
