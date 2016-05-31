require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << 'spec'
  t.pattern = "spec/*_spec.rb"
  t.test_files = FileList['spec/wage_slave/services/*_spec.rb', 'spec/wage_slave/*_spec.rb', 'spec/wage_slave/aba/*_spec.rb' ]
end