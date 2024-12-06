shader_type canvas_item;

uniform int active = 0;

void fragment() {
	vec4 originalColor = texture(TEXTURE, UV);
	
	COLOR = originalColor;
	
	if (active > 0) {
		COLOR = vec4(1.8, 0.85, 0.5, originalColor.a);
	}
	
}
