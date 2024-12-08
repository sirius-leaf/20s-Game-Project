shader_type canvas_item;

uniform vec4 colorMultiplier: source_color;
uniform float mixValue: hint_range(0.0, 1.0, 0.01);
uniform vec4 newColor: source_color;

void fragment() {
	vec4 originalColor = texture(TEXTURE, UV);

	originalColor *= colorMultiplier;

	vec3 color = mix(originalColor.rgb, newColor.rgb, mixValue);

	COLOR = vec4(color, originalColor.a);
}
