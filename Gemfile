source "https://rubygems.org"

gem "sinatra"
gem "sinatra-jsonp"
gem "puma"

gem "sinatra-asset-pipeline", require: 'sinatra/asset_pipeline'

if RUBY_PLATFORM == "java"
  gem "therubyrhino"
else
  gem "therubyracer"
end

gem "haml"

group :development, :text do
  gem "pry"
end

group :test do
  gem "rspec"
  gem "rack-test"
end
