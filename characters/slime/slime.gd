extends Node2D


func play_walk():
	%AnimationPlayer.play("walk")


func play_hurt():
	%AnimationPlayer.play("hurt")
	%AnimationPlayer.queue("walk")

func play_hit():
	%AnimationPlayer.play("attack")
	%AnimationPlayer.queue("walk")
