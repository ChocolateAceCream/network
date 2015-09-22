require "socket"
class Client
      def initialize( ip,port )
          @server = TCPSocket.open(ip,port )
          @listener = nil
          @sender = nil
          listen
          send
          @sender.join
          @listener.join
      end
      
      #this function receive messages from server and print in client window
      def listen
          @listener = Thread.new do
              loop {
                    messages = @server.gets.chomp
                    puts "#{messages}"
              }
          end
      end
     
      #this function send client's input to server. 
      #if client want to quit, close the socket
      def send
          puts "Please enter your name:"
          @sender = Thread.new do
                  loop {
                    messages = gets.chomp
                    @server.puts( messages )
                    if  messages == '-quit'
                        @server.close               
                        exit!
                    end
                  }
          end
      end
end

#Let user enter IP address and port number of server 
puts  "Please Enter Port of Server"
port=gets.chomp
puts  "Please Enter IP Address of Server"
ip=gets.chomp
Client.new( ip,port )