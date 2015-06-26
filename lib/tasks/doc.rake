require 'yard'
require 'yard/rake/yardoc_task'

# Use yard to build docs
begin
  project_root = File.expand_path(File.dirname(__FILE__) + '/../..')
  doc_dest_dir = File.join(project_root, 'doc')

  YARD::Rake::YardocTask.new(:doc) do |yt|
    yt.files = Dir.glob(File.join(project_root, 'lib', '**', '*.rb'))
    yt.options = ['--output-dir', doc_dest_dir,
                  '--readme', 'README.md',
                  '--title', 'RSpec-Solr Documentation',
                  '--files', 'MATCHERS.md']
  end
rescue LoadError
  desc 'Generate YARD Documentation'
  task :doc do
    abort 'Please install the YARD gem to generate rdoc.'
  end
end
