

desc 'Run test'
task :test do
  puts `ruby test/test-four-pillars.rb`
end

namespace :gem do
  desc 'Build gem'
  task :build do
    puts `gem build four-pillars.gemspec`
    puts "`gem push four-pillars-0.1.0.gem` to publish the gem."
    puts "See https://guides.rubygems.org/make-your-own-gem/ for details."
  end
end
