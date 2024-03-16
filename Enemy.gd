extends CharacterBody2D
class_name Enemy

@onready var player = $"../../Player"

var angle_cone_of_vision := deg_to_rad(30.0)
var angle_between_rays := deg_to_rad(5.0)

func generate_raycasts():
	if get_node_or_null("RayNode") == null:
		var ray_count := angle_cone_of_vision / angle_between_rays
		var ray_node := Node2D.new()
		ray_node.name = "RayNode"
		
		for index in ray_count:
			var ray := RayCast2D.new()
			ray.set_collision_mask_value(1,true)
			ray.set_collision_mask_value(2,true)
			var angle := angle_between_rays*(index - ray_count/2)
			ray.target_position = to_local(player.global_position)
			ray.rotate(angle)

			ray_node.add_child(ray)
			ray.enabled = true
		add_child(ray_node)

func direct_raycast_to_target():
	if get_node_or_null("RayNode") != null:
		for ray in get_node("RayNode").get_children():
			ray.target_position = to_local(player.global_position)
