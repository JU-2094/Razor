extends Node
var maxstats = {"health":100, "mana":100,"stamina":100, "lives":10}
var maxitems = {"bullets":50,"coins":100,"gems":10}
var stats = {"health":100, "mana":100,"stamina":100,"lives":3}
var items = {"bullets":30,"coins":0,"jewels":1}
var cur_item = "Bullets"
var cur_item_res = {"bullet": 'bullet'}

#Code from Blaze
# 9 states for player
# 5 states for bomb
#var anim = {"player":["right", "left", "up", "down", "carry_right", "carry_left", "carry_up", "carry_down", "grab_down"], \
#			"bombs":["bomb_up", "throw_bomb_right", "throw_bomb_left", "throw_bomb_up", "throw_bomb_down"]}
