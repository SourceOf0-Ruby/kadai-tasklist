# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

=begin
state_list = ["新規", "未着手", "着手", "遅延", "保留", "取消", "完了"];
(1..10).each do |num|
  state_list.each do |s|
    Task.create(status: s, content: 'test content ' + num.to_s);
  end
end
=end

