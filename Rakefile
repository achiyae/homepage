require "rake/testtask"
require "jekyll"
require "html-proofer"

Rake::TestTask.new(:test) do |t|
  t.libs = ["test"]
  t.pattern = "test/*_test.rb"
  t.warning = false
end

desc "Build, validate links, and run all tests"
task :check do
  Jekyll::Commands::Build.process("quiet" => true)
  HTMLProofer.check_directory("_site", disable_external: true).run

  sh "jekyll", "build", "--quiet", "--baseurl", "/homepage", "-d", "_site_base"

  Rake::Task[:test].invoke

  js_tests = Dir["test/*.test.mjs"]
  sh "node", "--test", *js_tests unless js_tests.empty?
end
