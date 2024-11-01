extends Node2D


func play_idle_animation():
	%AnimationPlayer.play("idle")


func play_walk_animation():
	%AnimationPlayer.play("walk")
	
func play_left_walk_animation():
	%AnimationPlayer.play("walk_left")
	
