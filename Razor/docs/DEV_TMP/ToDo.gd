"""
ToDo:
	Background jobs
		- Verify what happens with the objects in RAM after changing of scenes.
		  - how to make it persistent to the main process 
		- investigate if there's a recovery callback for crashes of current OSP
		- change variables to have them static and globally available for all nodes. (?)
		- check LOCKs for the tthread variable, since I modify that in a thread callback
		
	Network
		- IMPORTANT:
			When is trying to connect with server and fails, returns the result code 'rc'
			and we have to handle it by retrying more than only once 
		- Check for available client ports before connecting to server
		- Create 2 structures for context switching and keep updating for the foreground process
		- Create API for a peer to peer approach
		
		DESIGN spec:
			* The game process will connect to the remote host. And broadcast
			his IP to the other clients. 
			* When the client is hosting a game, by connecting tho the remote
			server it will broadcast his IP to the other clients. 
	Storage
		- needs design
			- https://docs.godotengine.org/en/3.1/tutorials/io/index.html
			- save user data
			- maybe save important network data
	Security
		- needs design
			- check IO doc
			- check Network. cipher the data stream before sending it
			for connecting to the server
			- also figure out a way to use the storage and don't
			hardcode the IPSERVER AND PORTS. like a hash kinda thing
		
	Server side:
		- 1 server - multiple games
			- Requires implementation and further investigation. The current idea is to have
			a coordinator running and dispatching the jobs to other processes. which will run
			in parallel and connect to the client. 
		
			- get requests from clients. generate an unique identifier and
			return it so it can be identifier with other peers and with the
			server
		- 1 server - 1 game
			- dedicated server, do the design
		- local servers ( CURRENT APPROACH) 
			- the remote server will only display current servers to other
			clients
	TODO:
		Puzzles: Create some puzzles
		Fog: Add fog that dissapears once you discover an area
		Add GUI inside game: Death space reference.
		
"""
