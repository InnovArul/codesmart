import socket
import sys

def initializer_server_socket(servername, port):
    print "starting server on %s:%s" % (servername, port)
    serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # set socket reuse to 1
    serversocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    try:
        serversocket.bind((servername, port))
    except socket.error, msg:
        print "Binding failed : Error = " + msg[0] + "\nmessage : " + msg[1]
        sys.exit(-1)

    serversocket.listen(1)  # currently accept only one Client
    return serversocket

def wait_for_client(serversocket):
    # blocking wait for a client
    (client, client_address) = serversocket.accept()

    print "client connected from " + client_address[0]
    return client
