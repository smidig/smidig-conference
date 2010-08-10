class Server
  def initialize(config)
    @config = config
  end

  def remote_task(taskname)
    task taskname do
      begin
        require 'net/ssh'
        require 'net/scp'

        login = "#{@config[:username]}@#{@config[:hostname]}"
        $stdout.puts "[#{login}] Logging in"
        Net::SSH.start(@config[:hostname], @config[:username]) do |ssh|
          yield Connection.new(login, ssh, @config[:application_path], @config[:environment], @config[:jruby])
        end
      rescue Net::SSH::AuthenticationFailed
        $stdout.puts "Authentication failed for #{@config[:username]}@#{@config[:hostname]}"
      end
    end
  end

  class Connection
    def initialize(login, ssh, application_path, environment, jruby=false)
      @login = login
      @ssh = ssh
      @application_path = application_path
      @environment = environment
      @rake = jruby ? "jruby -S rake" : "rake"
    end
    def rake(tasks)
      tasks = [tasks.strip] if tasks.instance_of? String
      tasks.each do |t|
        $stdout.puts "[#{@login}] #{@rake} #{t}"
        self.execute "cd #{@application_path} && #{@rake} #{t} RAILS_ENV=#{@environment}"
      end
    end
    def upload(io, path)
      $stdout.puts "[#{@login}] Uploading #{path}"
      path = File.join(@application_path, path) unless path.start_with? "/"
      @ssh.scp.upload! io, path
    end
    def upload_text(text, path)
      upload(StringIO.new(text), path)
    end
    def touch(path)
      $stdout.puts "[#{@login}] touch #{path}"
      path = File.join(@application_path, path) unless path.start_with? "/"
      execute "touch #{path}"
    end
    def exec(command)
      $stdout.puts "[#{@login}] #{command}"
      execute(command)
    end
    def execute(command)
      channel = @ssh.open_channel do |ch|
        ch.exec command do |ch, success|
          success or raise "could not execute command"
  
          ch.on_data do |c, data|
            $stdout.print data
          end
  
          ch.on_extended_data do |c, type, data|
            $stderr.print data
          end
  
          ch.on_request "exit-status" do |ch, data|
            exit_status = data.read_long
            exit_status == 0 or raise "command failed with status: #{exit_status}"
          end
        end
      end
      channel.wait
    end
  end
end
