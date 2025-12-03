extends CharacterBody2D

# Velocidades base
const SPEED := 90.0            # horizontal
const FLOAT_SPEED := 70.0      # vertical
const ACCEL := 6.0
const DECEL := 4.0

# Parámetros de las olas
var time := 0.0
const WAVE_FORCE_Y := 25.0       # potencia vertical
const WAVE_FORCE_X := 12.0       # potencia horizontal
const WAVE_SPEED := 1.6          # velocidad de oscilación

# Para joystick virtual (si lo usás)
var input_vector := Vector2.ZERO


func _physics_process(delta: float) -> void:
	time += delta

	# 1. INPUT MÓVIL O TECLADO (compatibles)
	var dir = _get_input()

	# 2. MOVIMIENTO LATERAL SUAVE (aceleración)
	velocity.x = lerp(velocity.x, dir.x * SPEED, ACCEL * delta)

	# 3. MOVIMIENTO VERTICAL SUAVE (flotación controlada)
	velocity.y = lerp(velocity.y, dir.y * FLOAT_SPEED, ACCEL * delta)

	# 4. Movimiento de olas (NO afecta input) → más natural
	var wave_y := sin(time * WAVE_SPEED) * WAVE_FORCE_Y
	var wave_x := cos(time * WAVE_SPEED * 0.8) * WAVE_FORCE_X

	velocity.x += wave_x * delta
	velocity.y += wave_y * delta * 0.5

	# 5. Movimiento final
	move_and_slide()


func _get_input() -> Vector2:
	# PRIORIDAD 1: joystick virtual
	if input_vector.length() > 0:
		return input_vector.normalized()

	# PRIORIDAD 2: teclado (para PC o debug)
	return Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)
