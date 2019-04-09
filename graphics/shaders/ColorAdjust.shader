shader_type canvas_item;
render_mode unshaded;

uniform vec3 delta;

/*
TODO: decide if we want individual uniforms for the hint range
uniform int delta_r : hint_range(-510, 510);
uniform int delta_g : hint_range(-510, 510);
uniform int delta_b : hint_range(-510, 510);
*/

void fragment() {
	vec4 final = texture(TEXTURE, UV);
	vec3 normalized = delta / 255.0;

	final.r = clamp(final.r + normalized.x, 0, 1);
	final.g = clamp(final.g + normalized.y, 0, 1);
	final.b = clamp(final.b + normalized.z, 0, 1);

	COLOR = final;
}
