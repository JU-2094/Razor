# Ports 49152-65535
# UDP   source port 2 bytes + destination port 2 bytes + checksum + data
# server for TCP usually 80
# API with remote server, and [PLAN] Peer to Peer
extends Node 

var socket_udp
# var IP_SERVER_R =  "195.201.179.80" # free server, see slack
var IP_SERVER_R = "192.168.1.166"
var PORT_SERVER = 50000
var PORT_CLIENT = 60000
var PORT_P2P =  31400
var MAX_CLIENT = 32
var ismaster
var data_send = {}
var data_get = {}
var lck_srv = Mutex.new()
var lck_cln = Mutex.new()
var lck_srv_cln = Mutex.new()
var net_peer

# onready var bgproc = preload("res://client/bgproc/bgproc.gd").new()
var bgproc = preload("res://client/bgproc/bgproc.gd").new()

func net_init():
	bgproc.bg_init(self)

func set_srv_ip(v_ip):
	IP_SERVER_R = v_ip

func net_conn2ser_rem():
	var rc = OK
	socket_udp = PacketPeerUDP.new()
	rc = socket_udp.set_dest_address(IP_SERVER_R, PORT_SERVER)
	if (rc!=OK):
		return rc
	rc = socket_udp.listen(PORT_CLIENT, IP_SERVER_R)
	if (rc!=OK):
		return rc
	data_send = null
	data_get = null
	bgproc.add_cts(self, 'srv2clt', 'srv2clt')
	return rc

func net_clsconn2ser_rem():
	socket_udp.close()
	bgproc.del_ctx('srv2clt')

# current instance will be the server
func net_iniserv():
	var rc = OK
	net_peer = NetworkedMultiplayerENet.new()
	rc = net_peer.create_server(PORT_P2P, MAX_CLIENT)
	ismaster = 1
	if (rc!=OK):
		return rc
	# add cts
	bgproc.add_cts(self, 'bcast2clt', 'bcast2clt',
					bgproc.BGPROC_TIMEOUT, 100)
	return rc

# server broadcast the clients data
func bcast2clt():
	rpc("sync_srv2clt", data_send)
	pass

# has a client have to update peer
remote func sync_srv2clt(data):
	# update data by reference
	# todo
	pass

func net_iniclnt(IP_HOST):
	var rc = OK
	net_peer = NetworkedMultiplayerENet.new()
	rc = net_peer.create_client(IP_HOST, PORT_P2P)
	ismaster = 0
	if (rc!=OK):
		return rc
	bgproc.add_cts(self, 'bcast2srv', 'bcast2srv',
				   bgproc.BGPROC_TIMEOUT, 100)

# the instance send his current data to server
func bcast2srv():
	rpc("sync_clt2srv", data_send)

# server has to update his data depending on peer
remote func sync_clt2srv(data):
	pass

func net_close():
	net_peer.close_connection()
	if ismaster==1:
		bgproc.del_ctx('bcast2clt')
	else:
		bgproc.del_ctx('bcast2srv')

# pass data var by reference, with dictionaries does the trick
func set_data_clt2srv(data_g):
	data_send = data_g

func set_data_srv2clt(data_g):
	data_get = data_g

# connect to remote server and get list of current servers/clients
func srv2clt():
	var clk=1
	
	# test of data_s
	var request = "conn2srv"
	var data_s = request.to_ascii()
	var buffer
	# get lock
	print("network here")
	if lck_srv.try_lock() == OK:
		lck_srv.lock()
		# request data to server
		# Todo cipher this before sending
		print("lock aquired")
		if socket_udp.is_listening():
			socket_udp.put_packet(data_s)
			while(clk%300):
				if socket_udp.get_available_packet_count() > 0:
					# todo decipher also the current data obtained
					buffer = socket_udp.get_packet()
					# decipher data stream
					print("RECEIVED from server: ", buffer)
					# Todo process the data
					
					# process data stream
					break
				clk = clk+1
		else:
			socket_udp.close()
			socket_udp.listen(PORT_CLIENT, IP_SERVER_R)
			socket_udp.set_dest_address(IP_SERVER_R, PORT_SERVER)
			
		lck_srv.unlock()

