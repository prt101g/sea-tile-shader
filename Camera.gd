extends Camera2D

const ZOOM_STEP = 1.1
const MIN_ZOOM = 0.6
const MAX_ZOOM = 4.0

const PAN_SPEED = 800

## Rectangle used to limit camera panning.
## Note that the built in camera limits do not work: they don't actually constrain the position of the camera.
## They only stop the view from moving. For the player, this makes the camera appear to "stick" at the edges of the map, 
## which is bad.
var limit_rect = null setget set_limit_rect

var mouse_captured = false


func _init():
	_snap_zoom_limits()


func _unhandled_input(event):
	if current:
		if event.is_action_pressed("view_zoom_in"):
			_zoom_in(event)
		if event.is_action_pressed("view_zoom_out"):
			_zoom_out()

		if event.is_action_pressed("view_pan_mouse"):
			mouse_captured = true
		elif event.is_action_released("view_pan_mouse"):
			mouse_captured = false

		if mouse_captured && event is InputEventMouseMotion:
			update_position(event.relative * -zoom)


# use _process for smoother scrolling
func _process(delta):
	if current:
		# smooth keyboard zoom
		if Input.is_action_pressed("view_zoom_in"):
			_zoom_in()
		if Input.is_action_pressed("view_zoom_out"):
			_zoom_out()

		var panning = Vector2()
		if Input.is_action_pressed("view_pan_up"):
			panning.y -= 1
		if Input.is_action_pressed("view_pan_down"):
			panning.y += 1
		if Input.is_action_pressed("view_pan_left"):
			panning.x -= 1
		if Input.is_action_pressed("view_pan_right"):
			panning.x += 1

		if panning.length_squared() > 0:
			update_position(panning.normalized() * PAN_SPEED * delta * zoom)


func update_position(translation):
	translate(translation)
	if limit_rect:
		_snap_to_limits()


func set_position(new_position : Vector2) -> void:
	global_position = new_position
	if limit_rect:
		_snap_to_limits()


# force position to be inside limit_rect
func _snap_to_limits():
	global_position.x = clamp(global_position.x, limit_rect.position.x, limit_rect.end.x)
	global_position.y = clamp(global_position.y, limit_rect.position.y, limit_rect.end.y)


func _zoom_in(event = null):
	var old_zoom = zoom
	zoom /= ZOOM_STEP
	_snap_zoom_limits()
	if event and event is InputEventMouse and old_zoom != zoom:
		# zoom in on mouse position
		update_position((-0.5 * get_viewport().size + event.position) * (old_zoom - zoom))


func _zoom_out():
	zoom *= ZOOM_STEP
	_snap_zoom_limits()


func set_zoom(new_zoom : Vector2) -> void:
	zoom = new_zoom
	_snap_zoom_limits()


func _snap_zoom_limits():
	zoom.x = clamp(zoom.x, MIN_ZOOM, MAX_ZOOM)
	zoom.y = clamp(zoom.y, MIN_ZOOM, MAX_ZOOM)


func set_limit_rect(rect):
	limit_rect = rect

	# center camera on given rect
	global_position.x = rect.position.x + rect.size.x / 2
	global_position.y = rect.position.y + rect.size.y / 2
	_snap_to_limits()
