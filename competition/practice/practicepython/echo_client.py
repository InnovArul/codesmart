import socket, time

# create client socket
clientsocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# connect to server
clientsocket.connect(("", 8000))

# after the client is connected to server, receive the message and print it
print 'connection established!\n'
msg = clientsocket.recv(1024)
print msg

keep_connection = 1

# send client message to server as long as user doesnt quit
while keep_connection:
    userinput = raw_input("Enter your message: ")
    if userinput == 'quit' or userinput == 'exit':
        keep_connection = 0

    clientsocket.sendall(userinput)
    time.sleep(0.5)

    # get server reply and print in client console
    reply = clientsocket.recv(1024)
    print "server reply : " + reply

print 'connection terminated!\n'


