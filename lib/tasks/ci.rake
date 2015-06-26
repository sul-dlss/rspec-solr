desc 'run continuous integration suite (tests, coverage, docs)'
task :ci do
  Rake::Task['rspec'].invoke
  Rake::Task['doc'].invoke
end
