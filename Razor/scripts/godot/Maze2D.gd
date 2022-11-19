extends Node2D
#The algorithm works as follows:
#1.- Create maze boundaries
#2.- Create rooms inside boundaries
#3.- Carve maze from empty
#4.- Connect rooms

#Size of map #######################################
@export (int) var x_size=12
@export (int) var y_size=12
@export (int) var node_size=1
@export (int) var hall_size=1

#Important Tiles ID ################################
var wall_tile=5
var carb_tile=3
var room_tile=8
var node_tile=10
var hall_tile=7
#Rooms Parameters###################################
#Make sure size of map is bigger than max_room_len or rooms would not be created
@export (int) var max_room_len=5
@export (int) var min_room_len=3



# Called when the node enters the scene tree for the first time.
func _ready():
	#1.-
	var maze_size=empty_maze()
	show_nodes(maze_size[0],maze_size[1])
	var nodes_list=gen_rooms(0)
	carv_maze(nodes_list,hall_tile)
	nodes_list=gen_rooms()
	#carv_maze()
	
	
	#2.-
	#gen_rooms(x,y,room_tile,empty_tile)
	#3.-
	#spam_tree()
	pass # Replace with function body.



#1.-# Preprocess ###############################################################
#1.1-Fill grid with the carbable tileset
func fill_maze(tile):
	var x=x_size*node_size + (x_size-1)*(hall_size)+1
	var y=y_size*node_size + (y_size-1)*(hall_size)+1
	for i in range(1,x):
		for j in range(1,y):
			$TileMap.set_cell(i,j,tile)
	return [x,y]
#1.2-Add frame to the maze
func frame_maze(x,y,tile):
	for i in range(0,x):
		$TileMap.set_cell(i,0,tile)
		$TileMap.set_cell(i,y,tile)
	
	for i in range(0,y):
		$TileMap.set_cell(0,i,tile)
		$TileMap.set_cell(x,i,tile)
	$TileMap.set_cell(x,y,tile)

func build_node(x,y,tile):
	for i in range(0,node_size):
		for j in range(0,node_size):
			$TileMap.set_cell(x+i,y+j,tile)

func show_nodes(x,y,tile=node_tile):
	for i in range(1,x,node_size+hall_size):
		for j in range(1,y,node_size+hall_size):
			build_node(i,j,tile)


#2.- #Mazes#####################################################################
#2.1 Grid Graph ###########################################################
func build_grid():
	#This grid contaqins randomly assigned weights, if you want to keep it modular the assigment needs to be done afterwards.
	var rng = RandomNumberGenerator.new()
	var ady_list={}
	for i in range(0,x_size):
		for j in range(0,y_size):
			var node_id=Vector2(i,j)
			ady_list[node_id]=[]
			#Conditions
			#Up
			if j+1<y_size:
				ady_list[node_id].append([Vector2(i,j+1),rng.randi_range(1,x_size*y_size)])
			#Down
			if j-1>=0:
				ady_list[node_id].append([Vector2(i,j-1),rng.randi_range(1,x_size*y_size)])
			#Left
			if i+1<x_size:
				ady_list[node_id].append([Vector2(i+1,j),rng.randi_range(1,x_size*y_size)])
			#Right
			if i-1>=0:
				ady_list[node_id].append([Vector2(i-1,j),rng.randi_range(1,x_size*y_size)])
	return ady_list
#2.2 ROOMS
#2.2.1 Fill Node3D
func fill_room(x,y,x_len,y_len,tile):
	var step=node_size+hall_size
	var init_tile =Vector2(step*x+1,(step*y)+1)
	var end_tile =Vector2(step*(x+x_len)-hall_size+1,step*(y+y_len)-hall_size+1)
	for i in range(init_tile[0],end_tile[0]):
		for j in range(init_tile[1],end_tile[1]):
			$TileMap.set_cell(i,j,tile)
			

#2.2.2 Add Node3D
func add_room(x,y,x_len,y_len,ady_list,tile=room_tile):
	#First pass check if space is available
	var del_nodes={}
	for i in range(x,x+x_len):
		for j in range(y,y+y_len):
			if not(ady_list.has(Vector2(i,j))):
				return [del_nodes,ady_list]
	fill_room(x,y,x_len,y_len,tile)
	for i in range(x,x+x_len):
		for j in range(y,y+y_len):
			del_nodes[Vector2(i,j)]=ady_list[Vector2(i,j)]
			ady_list.erase(Vector2(i,j))
	return [del_nodes,ady_list]
#2.2.3 Gen Rooms
func gen_rooms(tries=1000):
	var ady_list=build_grid()
	#print(len(ady_list))
	var rng = RandomNumberGenerator.new()
	var del_nodes={}
	#Main loop for placing roms
	for i in range(0,tries):
		var xc=rng.randi_range(0,x_size)
		var yc=rng.randi_range(0,y_size)
		var x_len=rng.randi_range(min_room_len,max_room_len)
		var y_len=rng.randi_range(min_room_len,max_room_len)
		var nodes_list=add_room(xc,yc,x_len,y_len,ady_list)
		ady_list=nodes_list[1]
		if len(nodes_list[0])!=0:
			for node in nodes_list[0]:
				del_nodes[node]=nodes_list[0][node]
	return [del_nodes,ady_list]
#2.3 Maze Carving########################################################################
#########################################################################################
func empty_maze(tile1=carb_tile,tile2=wall_tile):
	var maze_size=fill_maze(tile1)
	frame_maze(maze_size[0],maze_size[1],tile2)
	return maze_size


func carve_edge(edge_1,edge_2,tile):
	var step=node_size+hall_size
	#Check growing direction
	if edge_1[0]==edge_2[0]:
		#vertical
		if edge_1[1]<edge_2[1]:
			fill_room(edge_1[0],edge_1[1],1,2,tile)
		else:
			fill_room(edge_1[0],edge_2[1],1,2,tile)
	else:
		if edge_1[0]<edge_2[0]:
			fill_room(edge_1[0],edge_1[1],2,1,tile)
		else:
			fill_room(edge_2[0],edge_1[1],2,1,tile)
		#Vertical


func carv_maze(nodes_list,tile=room_tile):
	var del_nodes=nodes_list[0]
	var ady_list=nodes_list[1]
	var node_list=[]
	#1.-Initialize a tree with a single vertex, chosen arbitrarily from the graph.
	var rng = RandomNumberGenerator.new()
	var node_id=ady_list.keys()[rng.randi_range(0,len(ady_list))]
	#print(ady_list[node_id])
	node_list.append(node_id)
	#print(node_list)
	#Edge list
	var edges_list=[]
	
	#2.-Grow the tree by one edge: of the edges that connect the tree to vertices not yet in the tree, find the minimum-weight edge, and transfer it to the tree.
	#3.-Repeat step 2 (until all vertices are in the tree).
	var min_val=9999
	var curr_node=[]
	var curr_edge=[]
	while len(node_list)<len(ady_list):
		for i in node_list:
			for edge in ady_list[i]:
				if edge[1] < min_val:
					if not(edge[0] in node_list) and not(edge[0] in del_nodes.keys()):
						min_val=edge[1]
						curr_node=i
						curr_edge=edge
		#Aqui falta pa los que quedarin desconectados
		#print("here ",curr_edge)
		min_val=9999
		edges_list.append([curr_node,curr_edge[0]])
		node_list.append(curr_edge[0])
	print(node_list)
	#4 update maze:
	for i in edges_list:
		carve_edge(i[0],i[1],tile)
