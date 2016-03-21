source 'https://rubygems.org'

group :development do
  gem 'pry'
  gem 'pry-byebug'
end

group :acceptance do
  gem 'beaker-rspec'
end

if ENV['CONTROLREPO_gem'] == 'local'
  gem 'controlrepo', :path => '/Users/dylanratcliffe/git/controlrepo_gem'
else
  gem 'controlrepo',
    :git => 'https://github.com/dylanratcliffe/controlrepo_gem.git',
end

gem 'rspec-puppet',
  :git => 'https://github.com/adrienthebo/rspec-puppet.git',
  :branch => 'issue-343-puppet-4-modulepath'
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
