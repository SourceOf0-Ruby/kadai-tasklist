class SearchForm
  include ActiveModel::Model;
  
  attr_accessor :tab, :tag, :target, :keyword;
  
  def attributes(setHash={})
    {
      tab: @tab,
      tag: @tag,
      target: @target,
      keyword: @keyword
    }.merge(setHash)
  end
end
