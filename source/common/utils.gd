class_name Utils
extends Node

# https://www.rorydriscoll.com/2016/03/07/frame-rate-independent-damping-using-lerp/
static func damp(source, target, smoothing, delta):
	assert(smoothing > 0)
	assert(delta > 0)
	return lerp(source, target, 1.0 - pow(1.0/smoothing, delta))
