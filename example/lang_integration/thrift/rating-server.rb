$:.push('gen-rb')

require 'thrift'

require 'thrift/transport/server_socket'
require 'thrift/transport/buffered_transport'
require 'thrift/server/simple_server'

require 'rating'
require 'rating-impl'

# Thrift provides mutiple communication endpoints
#  - Here we will expose our service via a TCP socket
#  - Web-service will run as a single thread, on port 9090

handler = RatingImpl.new()
processor = Risk::Rating::Processor.new(handler)

transport = Thrift::ServerSocket.new(9090)
transportFactory = Thrift::BufferedTransportFactory.new()
server = Thrift::SimpleServer.new(processor, transport, transportFactory)

puts "Starting the Rating service..."
server.serve()

