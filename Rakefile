require "bundler/gem_tasks"

desc "Run tests"
task :test do
  # Do this is way to avoid forking another ruby process.
  # See: http://ngauthier.com/2012/02/quick-tests-with-bash.html
  root = File.dirname __FILE__
  Dir["#{root}/test/**/*_test.rb"].each do |test_file|
    begin
      require test_file
    rescue => ex
      puts ex
      puts ex.backtrace.join("\n")
      exit!
    end
  end
end
task :default => :test
