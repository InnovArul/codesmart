import server_socket

print "starting echo server..."
serversocket = server_socket.initializer_server_socket("", 8000)

while(True):
    print "waiting for client connection ... "

    # block until a client joins
    client = server_socket.wait_for_client(serversocket)

    # after the client has joined
    client.send("This is an echo server. To quit, enter 'quit' or 'exit' \n")

    exit_requested = 0
    while not exit_requested:
        # attempt reading 1024 bytes
        data = client.recv(1024)

        # print the message
        print "message from client: " + data + "\n"

        # validate the message
        if "exit" in data or "quit" in data :
            exit_requested = 1
        else:
            print "replying to the client ..."

        msg = "you wrote " + data + ""
        client.sendall(msg)

    # if the client has opted to exit
    client.send("thanks for talking!\n\n")
    client.close()
