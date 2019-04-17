class Relationship < ApplicationRecord
  belongs_to :tag;
  validates :tag_id, presence: true, uniqueness: { scope: [:task_id] };
  
  belongs_to :task;
  validates :task_id, presence: true, uniqueness: { scope: [:tag_id] };
end
