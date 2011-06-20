class Role < ActiveRecord::Base
  belongs_to :roleable, :polymorphic => true
  has_and_belongs_to_many :menus

  validates_presence_of :name
  validates_presence_of :menus

  has_many :users

  def can_edit?
    users.empty?
  end

  def menu_groups
    groups = MenuGroup.find(menus.map(&:menu_group_id).uniq)
    groups.each do |g|
      menus.select{|m| m.menu_group_id == g.id}.sort_by(&:seq).each do |m|
        g.add_menu(m)
      end
    end
    groups
  end
end