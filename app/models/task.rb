class Task < ApplicationRecord
  
  belongs_to :user;
  validates :user_id , presence: true;
  
  belongs_to :state;
  validates :state_id , presence: true;
  
  validates :title, presence: true, length: { maximum: 255 };
  
  validates :content, length: { maximum: 100000 };
  
  has_many :relationships, dependent: :destroy;
  has_many :tags, through: :relationships, source: :tag;
  
  attr_accessor :tags_list;
  
  #タグ文字列
  def tags_str
    if @tags_list
      @tags_list.join(' ');
    else 
      self.tags.map(&:name).join(' ');
    end
  end
  
  def tags_str=(tags_str)
    tags_str = "" if tags_str.blank?;
    @tags_list = tags_str.split(/[ ,　]/).reject(&:blank?);
  end
  
  # タスクを検索する
  # @param targets: 対象のカラム名の配列
  # @param keyword: 検索する文字列（空白でor検索）
  # @return: 検索結果
  def self.search(targets, keyword)
    result = self;
    patterns = keyword.split(/[ ,　]/).reject(&:blank?);
    patterns.each do |pattern|
      sql_array = [''];
      targets.each_with_index do |target, index|
        sql_array[0] += ' OR ' if index > 0;
        sql_array[0] += "#{target} LIKE ?";
        sql_array.push("%#{pattern}%");
      end
      result = result.where(sql_array);
    end
    if result.count == 1
      return Task.where(id: result.ids);
    else
      return result;
    end
  end
  
  # タグを整理する（タグの追加・削除）
  def amend_tags
    unless self.new_record? || self.relationships.count == 0
      if !@tags_list || @tags_list.length == 0
        self.relationships.destroy_all;
        return true;
      end
      self.relationships.joins(:tag).where.not(tags: { name: @tags_list }).delete_all;
    end
    @tags_list.each do |tag_name|
      next if tag_name == "";
      tag_name.slice!(/^#/);
      tag = Tag.find_or_create_by(name: tag_name);
      if self.new_record? || !self.relationships.find_by(tag_id: tag.id)
        relationship = self.relationships.build(tag_id: tag.id);
        return false unless relationship.save;
      end
    end
    return true;
  end
  
end
