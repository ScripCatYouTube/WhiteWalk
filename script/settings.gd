extends Node

func rand(a,w):
	randomize()
	return int(rand_range(a,w))
func cristals():
	return rand(4,5)
func blocks():
	return rand(15,90)
func npcs():
	return rand(0,5)
func mobs():
	return rand(0,1)
func cordinates(x,y):
	return [rand(0,x),rand(0,y)]
func block():
	var random_number = rand(0,20)
	if random_number < 10:
		return 0
	else:
		return 1
func chance():
	var random_number = rand(0,20)
	if random_number < 10:
		return false
	else:
		return true
func choose(count):
	return rand(0,count)
	
