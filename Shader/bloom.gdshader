shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable,filter_nearest;
uniform float threshold : hint_range(0.0, 1.0) = 1.0;

void fragment(){
	vec4 screen = texture(SCREEN_TEXTURE, FRAGCOORD.xy * SCREEN_PIXEL_SIZE);
	
	float maxValue = max(max(screen.r, screen.g), screen.b);
	maxValue = step(threshold, maxValue);
	screen.rgb += vec3(maxValue);
	
	COLOR = screen;
}