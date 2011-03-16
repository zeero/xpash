require 'rake'
require 'spec/rake/spectask'

desc "Run all specifications with RCov"

Spec::Rake::SpecTask.new("spec:rcov") {|t|
  t.spec_files = FileList["spec/**/*_spec.rb"]
  t.rcov = true
  t.rcov_opts = ["--exclude", "spec"]
}

