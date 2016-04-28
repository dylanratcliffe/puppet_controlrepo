source 'https://rubygems.org'

group :development do
  gem 'pry'
  gem 'pry-byebug'
end

group :acceptance do
  gem 'beaker-rspec'
end

if ENV['ONCEOVER_gem'] == 'local'
  gem 'onceover', :path => '/Users/dylanratcliffe/git/controlrepo_gem'
else
  gem 'onceover',
    :git => 'https://github.com/dylanratcliffe/controlrepo_gem.git'
end

gem 'rspec-puppet'
gem "rake"
gem 'yard'
#########################
gem 'json'
gem 'puppetlabs_spec_helper'
gem 'rspec'
gem 'beaker'
gem 'bundler'
gem 'r10k'
gem 'puppet'
gem 'git'
