class Task < ApplicationRecord
  
  belongs_to :user;
  validates :user_id , presence: true;
  
  belongs_to :state;
  validates :state_id , presence: true;

  validates :title, presence: true, length: { maximum: 255 };
  
  validates :content, length: { maximum: 100000 };
  
  # タスクを検索する
  # @param targets: 対象のカラム名の配列
  # @param keyword: 検索する文字列（空白でor検索）
  # @return: 検索結果
  def self.search(targets, keyword)
    result = self;
    patterns = keyword.split(/[ ,　]/);
    patterns.each do |pattern|
      sql_array = [''];
      targets.each_with_index do |target, index|
        sql_array[0] += ' OR ' if index > 0;
        sql_array[0] += "#{target} LIKE ?";
        sql_array.push("%#{pattern}%");
      end
      result = result.where(sql_array);
    end
    return result;
  end
  
end
