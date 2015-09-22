
require "socket"
require 'open-uri'
class Server
      def initialize( ip, port )
          @server = TCPServer.open( ip, port )
          @socket = Hash.new
          @clients = Hash.new
          @socket[:server] = @server
          @socket[:clients] = @clients
          chat
      end
      
      #this function creates new client in hash table and check its uniqueness
      def chat
          loop {  
                Thread.start(@server.accept) do | client |
                    chat_name = client.gets.chomp                    
                    @socket[:clients].each do |else_name, else_client|
                        while chat_name == else_name
                              client.puts "This name already exist,please re-enter"
                              chat_name = client.gets.chomp         
                        end
                    end
                    
                    puts "#{chat_name} has established connection"
                    @socket[:clients][chat_name] = client
                    client.puts "Welcome to the chatting room, enjoy chatting!\nEnter '-quit' to exit program"
                    listen( chat_name, client )
                end 
          }.join
      end
      
      # this function listen to each client's input and exchange message between clients
      def listen( chat_name, client )
          loop {
                messages = client.gets.chomp
                #if client want to quit, remove client from hash table
                if  messages=='-quit'
                    puts "#{chat_name} has left room"
                    @socket[:clients].delete(chat_name)
                    Thread.kill self
                else
                
                #exchange message between clients
                @socket[:clients].each do |each_name, each_client|
                    if  chat_name != each_name         
                        each_client.puts "#{chat_name.to_s}: #{messages}"       
                    else
                        client.puts "Me: #{messages}"
                    end
                end
          end
          }
      end
end

#get ip address and port number from user 
ip=open('http://whatismyip.akamai.com').read
puts "Suggested IP address is:"
p ip
puts"Enter IP address of server"
ip = gets.chomp
puts "Enter port of server"
port=gets.chomp
Server.new( ip,port )
