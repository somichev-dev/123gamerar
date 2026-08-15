extends TextureRect

func change_anim(anim_id: int):
	if anim_id not in range(1, 6): return
	$AnimationPlayer.current_animation = "timer_animations/clock_animation_%d" % anim_id
