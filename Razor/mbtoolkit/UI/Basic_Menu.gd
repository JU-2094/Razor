extends Control

func ready():
	# with this is possible to use the keyboard
	# In the inspector needs to set the focus neighbour top and down
	$VBoxContainer.grab_focus()
	

func _on_QuitButton_pressed():
	get_tree().quit()
