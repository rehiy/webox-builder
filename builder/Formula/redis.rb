class Redis < Formula
    desc "Persistent key-value database, with built-in net interface"
    homepage "https://redis.io/"
    url "http://download.redis.io/releases/redis-6.0.5.tar.gz"
    sha256 "42cf86a114d2a451b898fcda96acd4d01062a7dbaaad2801d9164a36f898f596"

    depends_on "openssl@1.1"

    def install
      system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"
    end

    plist_options :manual => "redis-server #{HOMEBREW_PREFIX}/etc/redis/redis.conf"

    def plist
      <<~EOS
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>KeepAlive</key>
            <dict>
            <key>SuccessfulExit</key>
            <false/>
            </dict>
            <key>Label</key>
            <string>#{plist_name}</string>
            <key>ProgramArguments</key>
            <array>
            <string>#{opt_bin}/redis-server</string>
            <string>#{etc}/redis/redis.conf</string>
            <string>--daemonize no</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
            <key>WorkingDirectory</key>
            <string>#{var}</string>
            <key>StandardErrorPath</key>
            <string>#{var}/log/redis/error.log</string>
            <key>StandardOutPath</key>
            <string>#{var}/log/redis/redis.log</string>
        </dict>
        </plist>
      EOS
    end

    test do
      system bin/"redis-server", "--test-memory", "2"
      %w[run db/redis log].each { |p| assert_predicate var/p, :exist?, "#{var/p} doesn't exist!" }
    end
end
