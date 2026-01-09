extends Area2D

#Despawns arrows you miss
func _on_area_entered(area: Area2D) -> void:
	area.get_parent().queue_free()
