extends NavigationRegion2D

func _ready():
	# Create a new NavigationPolygon
	var nav_polygon = NavigationPolygon.new()
	
	# Define the outer points for the polygon (navigable area)
	var outer_points = [
		Vector2(-1000, -1000),
		Vector2(1000, -1000),
		Vector2(1000, 1000),
		Vector2(-1000, 1000)
	]
	
	# Add the outer points as the main outline
	var outer_outline = PackedVector2Array(outer_points)
	nav_polygon.add_outline(outer_outline)
	
	# Define points for the first hole (non-navigable area)
	var hole1_points = [
		Vector2(100, 100),
		Vector2(200, 100),
		Vector2(200, 200),
		Vector2(100, 200)
	]
	
	# Add the first hole
	var hole1_outline = PackedVector2Array(hole1_points)
	nav_polygon.add_outline(hole1_outline)
	
	# Define points for the second hole
	var hole2_points = [
		Vector2(300, 300),
		Vector2(400, 300),
		Vector2(400, 400),
		Vector2(300, 400)
	]
	
	# Add the second hole
	var hole2_outline = PackedVector2Array(hole2_points)
	nav_polygon.add_outline(hole2_outline)
	
	# Build the navigation polygon with holes
	nav_polygon.make_polygons_from_outlines()
	
	# Assign the NavigationPolygon to the NavigationRegion2D
	self.navigation_polygon = nav_polygon

	# Trigger the custom draw function for debugging
	queue_redraw()


# Debug draw to visualize polygons
func _draw():
	var outer_color = Color(0, 1, 0, 0.3)  # Green, semi-transparent
	var hole_color = Color(1, 0, 0, 0.3)   # Red, semi-transparent
	
	# Create PackedColorArrays for the polygons
	var outer_color_array = PackedColorArray([outer_color, outer_color, outer_color, outer_color])  # Four vertices, same color
	var hole_color_array = PackedColorArray([hole_color, hole_color, hole_color, hole_color])    # Four vertices, same color
	
	# Draw the outer polygon with a PackedColorArray
	draw_polygon(navigation_polygon.get_outline(0), outer_color_array)
	
	# Draw the holes (internal polygons) with a PackedColorArray
	for i in range(1, navigation_polygon.get_outline_count()):
		draw_polygon(navigation_polygon.get_outline(i), hole_color_array)
