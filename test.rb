require 'thread'
require 'openssl'

Thread.abort_on_exception = true

expected = '0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33'
threads  = []
mutex    = Mutex.new
compared = 0

puts 'Starting threads...'

100.times do |n|
  threads << Thread.new do
    mutex.synchronize { puts "Starting thread #{n + 1}..." }

    loop do
      got = OpenSSL::Digest::SHA1.hexdigest('foo')

      unless got == expected
        raise "#{got} is not #{expected}"
      end

      mutex.synchronize { compared += 1 }
    end
  end
end

threads << Thread.new do
  loop do
    mutex.synchronize do
      puts "Verified #{expected.inspect} #{compared} times so far"
    end

    sleep 10
  end
end

threads.each(&:join)
