source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in warm-boot.gemspec
gemspec

group :test do
  gem 'codeclimate-test-reporter', require: false
  gem 'rspec', '~> 3.8'
  gem 'simplecov', require: false
end
