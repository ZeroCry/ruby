#! ./miniruby

exit if defined?(CROSS_COMPILING) and CROSS_COMPILING
ruby = ENV["RUBY"]
unless ruby
  load './rbconfig.rb'
  ruby = "./#{RbConfig::CONFIG['ruby_install_name']}#{RbConfig::CONFIG['EXEEXT']}"
end
unless File.exist? ruby
  puts "#{ruby} is not found."
  puts "Try `make' first, then `make test', please."
  exit false
end
ARGV[0] and opt = ARGV[0][/\A--run-opt=(.*)/, 1] and ARGV.shift

$stderr.reopen($stdout)
error = ''

srcdir = File.expand_path('..', File.dirname(__FILE__))
`#{ruby} #{opt} -W1 #{srcdir}/basictest/test.rb #{ARGV.join(' ')}`.each_line do |line|
  if line =~ /^end of test/
    puts "\ntest succeeded\n"
    exit true
  end
  error << line if %r:^(basictest/test.rb|not): =~ line
end
puts
puts error
puts "test failed\n"
exit false
