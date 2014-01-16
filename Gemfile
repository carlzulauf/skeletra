source "https://rubygems.org"

gem "sinatra"
gem "sinatra-jsonp"
gem "puma"

gem "sinatra-asset-pipeline", require: 'sinatra/asset_pipeline'

gem "haml"

group :development, :text do
  gem "pry"
end

group :test do
  gem "rspec"
  gem "rack-test"
end

platform :rbx do
  gem "json"
  gem "rb-readline"
  gem "rubysl-base64"
  gem "rubysl-enumerator"
  gem "rubysl-securerandom"
  gem "rubysl-singleton"
end

platform :jruby do
  gem "therubyrhino"
end

platform :rbx, :ruby do
  gem "therubyracer"
end
