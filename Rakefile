require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:unit) do |t|
  t.fail_on_error = true
  t.rspec_opts = "--tag unit"
  t.pattern = 'spec/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:integration) do |t|
  t.fail_on_error = false
  t.rspec_opts = "--tag integration"
  t.pattern = 'spec/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:integration1) do |t|
  t.fail_on_error = false
  t.rspec_opts = "--tag integration1"
  t.pattern = 'spec/**/*_spec.rb'
end

task :default => :integration

