Rails.application.config.generators do |g|
  g.stylesheets false;
  g.javascripts false;
  g.helper false;
  g.assets false;      # CoffeeScript作らない
  g.skip_routes true;  # Routes自動追加しない
end