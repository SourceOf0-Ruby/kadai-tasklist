class Tag < ApplicationRecord
  
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 };
  
  has_many :relationships;
  has_many :tasks, through: :relationships, source: :task;
  
end
