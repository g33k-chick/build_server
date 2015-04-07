require 'socket'                                    # Require socket from Ruby Standard Library (stdlib)

host = 'localhost'
port = 2000

server = TCPServer.open(host, port)                 # Socket to listen to defined host and port
puts "Server started on #{host}:#{port} ..."        # Output to stdout that server started

loop do                                             # Server runs forever
  client = server.accept                            # Wait for a client to connect. Accept returns a TCPSocket

  lines = []
  while (line = client.gets.chomp) && !line.empty?  # Read the request and collect it until it's empty
    lines << line
  end
  puts lines                                        # Output the full request to stdout

  # index.html HTTP/1.1
  # index.html

  filename = lines[0].gsub(/GET \//, '').gsub(/ HTTP.*/, '')
  headers = []

  if File.exists?(filename)
  	body = File.read(filename)
  	headers << "HTTP/1.1 200 OK"
  	headers << "Content-type: text/html"
  else
  	body = "File not found\n"
  	headers << "HTTP/1.1 404 Not Found"
  	headers << "Content-type: text-plain"
  end

  headers << "Content-Length"
  headers << "Connection: close"
  headers = headers.join("\r\n")
  response = [headers, body].join("\r\n\r\n")

  client.puts(response)		                        # Output the current time to the client
  client.close                                      # Disconnect from the client
end