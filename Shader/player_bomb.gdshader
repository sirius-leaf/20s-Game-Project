shader_type canvas_item;

void fragment() {
	vec4 originalColor = texture(TEXTURE, UV);

	float blink = round(sin(TIME * 40.0) * 0.5 + 0.5);

	if (blink > 0.5) {
		COLOR = vec4(1.8, 0.85, 0.5, originalColor.a);
	} else {
		COLOR = originalColor;
	}
}
