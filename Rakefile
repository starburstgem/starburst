require 'bundler/setup'
require 'bundler/gem_tasks'
require 'appraisal'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => ['appraisal:install']

task :appraise => ['appraisal:install'] do |t|
  exec 'rake appraisal'
end