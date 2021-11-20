# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'config'
gem 'aws-sdk-s3'
# aws-sdk-s3で必要だと怒られたが、なぜ勝手に入れてくれないのか？
gem 'nokogiri'

group :test do
  gem 'rspec'
end