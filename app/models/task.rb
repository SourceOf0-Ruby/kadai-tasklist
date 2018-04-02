class Task < ApplicationRecord
  
  belongs_to :user;
  validates :user_id , presence: true;
  
  validates :status , presence: true, length: { maximum: 10 };
  
  validates :title, presence: true, length: { maximum: 255 };
  
  validates :content, length: { maximum: 100000 };
  
end
