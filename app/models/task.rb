class Task < ApplicationRecord
  
  belongs_to :user;
  validates :user_id , presence: true;
  
  belongs_to :state;
  validates :state_id , presence: true;
  
  validates :title, presence: true, length: { maximum: 255 };
  
  validates :content, length: { maximum: 100000 };
  
  has_many :relationships;
  has_many :tags, through: :relationships, source: :tag;
  
  #タグ文字列
  def tags_str
    self.tags.map(&:name).join(' ');
  end
  def tags_str=(tags_str)
    tags_str = [] if tags_str.blank?;
    amend_tags(tags_str.split(/[ ,　]/).reject(&:blank?));
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
  
  # タグを追加する
  # @param tag_names: タグの名前の配列
  def add_tags(tag_names)
    tag_names.each do |tag_name|
      next if tag_name == "";
      tag_name.slice!(/^#/);
      tag = Tag.find_or_create_by(name: tag_name);
      self.relationships.find_or_initialize_by(tag_id: tag.id);
    end
  end
  
  # タグを整理する（タグの追加・削除）
  # @param tag_names: タグの名前の配列
  def amend_tags(tag_names)
    if !tag_names || tag_names.length == 0
      self.relationships.destroy_all;
      return;
    end
    self.relationships.joins(:tag).where.not(tags: { name: tag_names }).delete_all;
    add_tags(tag_names);
  end
  
end
