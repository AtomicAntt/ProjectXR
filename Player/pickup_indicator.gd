@tool
extends Line3D

# Variable names are from: https://docs.godotengine.org/en/latest/tutorials/math/beziers_and_curves.html

## Number of segments used in generating the pickup_indicator line.
@export var num_segments: int = 20
@export var curve_height: float = 0.5

## Set this to true if you want to start generating points.
var generating_points: bool = false
## Also set this to ensure a destination is given
var destination_object: Node3D

## Starts the pickup indicator given the object it can pick up from a range.
func start(new_destination_object: Node3D) -> void:
	generating_points = true
	destination_object = new_destination_object

## Stops the pickup indicator.
func stop() -> void:
	generating_points = false
	points = []

## Generate points given a global_position destination (p2)
## Likely used by FunctionPickup whenever a ranged grab is available.
func generate_points(p2: Vector3) -> void:
	points = []
	
	var p0: Vector3 = global_position
	
	# This is the midpoint between the origin and the destination, with a given curve_height as shown in a Quadratic Bezier curve.
	var p1: Vector3 = (p2 + p0)/2 + Vector3(0, curve_height, 0)
	for i in range(num_segments+1):
		var t: float = float(i)/float(num_segments)
		var q0: Vector3 = p0.lerp(p1, t)
		var q1: Vector3 = p1.lerp(p2, t)
		var r: Vector3 = q0.lerp(q1, t)
		
		points.append(r)

## Generate points given a global_position destination (p3)
## Likely used by FunctionPickup whenever a ranged grab is available.
## This is the new way of doing it.
func generate_points_cubic(p3: Vector3) -> void:
	points = []
	
	var p0: Vector3 = global_position
	
	# This is the y direction of the hand faces * magnitude of 0.1
	
	var offset: Vector3 = get_parent().transform.basis.y * 0.1
	var p1: Vector3 = p0 + offset
	# Midpoint with an offset of the forward direction of the hand.
	var p2: Vector3 = ((p3 + p0)/2) + offset
	for i in range(num_segments+1):
		var t: float = float(i)/float(num_segments)
		var q0: Vector3 = p0.lerp(p1, t)
		var q1: Vector3 = p1.lerp(p2, t)
		var q2: Vector3 = p2.lerp(p3, t)
		
		var r0: Vector3 = q0.lerp(q1, t)
		var r1: Vector3 = q1.lerp(q2, t)
		
		var s = r0.lerp(r1, t)
		
		points.append(s)

func _physics_process(_delta: float) -> void:
	if generating_points and is_instance_valid(destination_object):
		var destination_position = destination_object.global_position
		generate_points_cubic(destination_position)
