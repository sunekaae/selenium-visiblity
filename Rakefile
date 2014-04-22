require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:unit) do |t|
  t.fail_on_error = false
  t.rspec_opts = "--tag unit"
  t.pattern = 'spec/**/*_spec.rb'
end
task :default => :unit

