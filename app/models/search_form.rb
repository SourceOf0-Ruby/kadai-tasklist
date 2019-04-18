class SearchForm
  include ActiveModel::Model;
  
  attr_accessor :tab, :tag, :target, :keyword;
  
  def self.target_str_list
    [
      ['検索対象指定なし', 0],
      ['タイトル', 1],
      ['内容', 2]
    ];
  end
  
  def self.search_target
    [
      ['title', 'content'],
      ['title'],
      ['content']
    ];
  end
  
  def attributes(setHash={})
    {
      tab: @tab,
      tag: @tag,
      target: @target,
      keyword: @keyword
    }.merge(setHash)
  end
  
  def get_task(user)
    if @tag.blank?
      tasks = user.tasks;
    else
      tag = Tag.find(@tag);
      if tag
        tasks = user.tasks.where(id: Relationship.where(tag_id: tag.id).select(:task_id));
      else
        tasks = Task.none;
      end
    end
    
    unless @keyword.blank?
      tasks = tasks.search(SearchForm.search_target[@target.to_i], @keyword);
    end
    
    return tasks;
  end
end
