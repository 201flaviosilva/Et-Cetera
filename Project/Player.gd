extends KinematicBody

export (float) var NORMAL_SPEED: float = 10
export (float) var JUMP_FORCE: float = 10
export (Vector3) var GRAVITY: Vector3 = Vector3.DOWN * 15
export (float) var MOUSE_SENSIVITY: float = 0.3

var velocity: Vector3 = Vector3.ZERO
var is_jumping: bool = false

onready var CAMERA: Camera = $Camera

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _process(delta: float) -> void:
	var input = Vector3.ZERO
	var speed = NORMAL_SPEED
	
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += JUMP_FORCE
		is_jumping = true
	else: is_jumping = false
	
	# Move
	if Input.is_action_pressed("run"): speed = NORMAL_SPEED * 1.5
		
	if Input.is_action_pressed("move_forward"): input += -speed * transform.basis.z
	if Input.is_action_pressed("move_backward"): input += speed * transform.basis.z
	
	if Input.is_action_pressed("move_left"): input += -speed * transform.basis.x
	if Input.is_action_pressed("move_right"): input += speed * transform.basis.x
	
	velocity.x = input.x
	velocity.z = input.z
	pass

func _physics_process(delta: float) -> void:
	velocity += GRAVITY * delta
	
	var snap_vector = Vector3.DOWN if not is_jumping else Vector3.ZERO
	
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector3.UP, true, 4, deg2rad(70))
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * MOUSE_SENSIVITY))
		CAMERA.rotate_x(deg2rad(-event.relative.y * MOUSE_SENSIVITY))
		CAMERA.rotation.x = clamp(CAMERA.rotation.x , deg2rad(-90), deg2rad(90))
		
	if Input.is_action_pressed("ui_cancel"): 
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().set_input_as_handled()
		pass
		
	if Input.is_action_just_pressed("click") and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE: 
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass
