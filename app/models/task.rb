class Task < ApplicationRecord
  
  belongs_to :user;
  validates :user_id , presence: true;
  
  belongs_to :state;
  validates :state_id , presence: true;

  validates :title, presence: true, length: { maximum: 255 };
  
  validates :content, length: { maximum: 100000 };
  
end
