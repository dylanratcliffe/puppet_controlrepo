source 'https://rubygems.org'

group :development do
  gem 'pry'
  gem 'pry-byebug'
end

group :acceptance do
  gem 'beaker-rspec'
end

if ENV['ONCEOVER_gem'] == 'local'
  gem 'onceover', :path => '/Users/dylanratcliffe/git/onceover'
else
  gem 'onceover',
    :git => 'https://github.com/dylanratcliffe/onceover.git'
end

gem 'beaker', :git => 'https://github.com/puppetlabs/beaker.git'
