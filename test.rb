require 'thread'
require 'openssl'

Thread.abort_on_exception = true

expected = '0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33'
threads  = []
mutex    = Mutex.new

puts 'Starting threads...'

100.times do |n|
  threads << Thread.new do
    mutex.synchronize { puts "Starting thread #{n + 1}..." }

    loop do
      got = OpenSSL::Digest::SHA1.hexdigest('foo')

      unless got == expected
        raise "#{got} is not #{expected}"
      end
    end
  end
end

threads.each(&:join)
