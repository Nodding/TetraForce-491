extends Enemy

var movetimer_length = 150
var movetimer = 0

export var boss = false

func _ready():
	movedir = rand_direction()
	if boss:
		MAX_HEALTH = 6
		DAMAGE = 1
	health = MAX_HEALTH

func _physics_process(delta):
	if !network.is_map_host() || is_dead():
		sprite.flip_h = (spritedir == "Left")
		return
	
	loop_movement()
	loop_spritedir()
	loop_damage()
	loop_holes()
	
	anim_switch("walk")
	
	if movedir == Vector2.ZERO:
		anim_switch("idle")
	
	if movetimer > 0:
		movetimer -= 1
		
	if movetimer == 0 || is_on_wall() && hitstun == 0:
		movedir = rand_direction()
		movetimer = movetimer_length
	
	if movetimer == 50:
		movedir = Vector2.ZERO
		use_weapon("Bow")
		network.peer_call(self, "use_weapon", ["Bow"])
