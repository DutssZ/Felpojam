extends ProgressBar
var playing = false
var fadein = false
var rate = 1.3

var wait = 0
var maxWait = 1

signal blackout()
signal fadeEnded()

func _process(delta: float) -> void:
	if wait>0: wait -= delta
	
	if (playing && fadein): 
		self.value = min(100, (value+delta)*rate)
		if (self.value >= 100): 
			fadein = false
			fill_mode = FILL_BEGIN_TO_END
			blackout.emit()
	elif (playing && !fadein && wait <= 0): 
		self.value = max(0, (value-delta)/rate)
		if (self.value <= 0):
			set_mouse_filter(MOUSE_FILTER_IGNORE)
			playing = false
			fill_mode = FILL_END_TO_BEGIN
			fadeEnded.emit()


func play():
	if (!playing):
		playing = true
		fadein = true
		wait = maxWait
		fill_mode = FILL_END_TO_BEGIN
		set_mouse_filter(MOUSE_FILTER_STOP)
