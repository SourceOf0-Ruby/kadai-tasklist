class State < ApplicationRecord
  
  validates :name , presence: true, length: { maximum: 20 };
  
  validates :view_class , presence: true, length: { maximum: 20 };
  
end
