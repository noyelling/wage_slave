require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << 'spec'
  t.pattern = "spec/*_spec.rb"
  t.test_files = FileList['spec/models/*_spec.rb', 'spec/services/*_spec.rb']
end