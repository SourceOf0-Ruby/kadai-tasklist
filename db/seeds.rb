# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

State.create(name: "新規",   view_class: "info",    is_effective: true);
State.create(name: "未着手", view_class: "warning", is_effective: true);
State.create(name: "着手",   view_class: "primary", is_effective: true);
State.create(name: "遅延",   view_class: "danger",  is_effective: true);
State.create(name: "保留",   view_class: "info",    is_effective: true);
State.create(name: "取消",   view_class: "default", is_effective: false);
State.create(name: "完了",   view_class: "success", is_effective: false);
