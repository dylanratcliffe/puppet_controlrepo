source 'https://rubygems.org'

group :development do
  gem 'pry'
  gem 'pry-byebug'
end

if ENV['ONCEOVER_gem'] == 'local'
  gem 'onceover', :path => '/Users/dylan/git/onceover'
  gem 'onceover-octocatalog-diff', :path => '/Users/dylan/git/onceover-octocatalog-diff'
else
  gem 'onceover', :git => 'https://github.com/dylanratcliffe/onceover.git'#, :branch => 'issue-51'
  gem 'onceover-octocatalog-diff', :git => 'https://github.com/dylanratcliffe/onceover-octocatalog-diff.git'
end

gem 'puppet', ENV['PUPPET_version'] || '~> 5'
