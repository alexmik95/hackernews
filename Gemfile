source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in hackernews.gemspec
gemspec

group :test do
  gem 'rspec', '~> 3.8.0'
  gem 'vcr', '~> 5'
  gem 'dotenv', '~> 2.1'
  gem 'simplecov', require: false
end
