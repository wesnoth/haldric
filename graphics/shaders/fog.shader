shader_type canvas_item;

uniform float intensity : hint_range(0.1, 2.0);
uniform sampler2D noise : hint_albedo;
uniform vec2 offset;

void fragment() {
	vec4 cover = texture(TEXTURE, UV);
	vec2 coord = SCREEN_UV + (vec2(offset.x, -offset.y));
	
	vec4 n = texture(noise, coord + TIME * 0.01);
	vec4 n2 = texture(noise, vec2(coord.y, coord.x) - TIME * 0.01);
	
	vec4 final = mix(n, n2, 0.5);
	
	final.a = cover.a;
	
	if (final.a > 0.0) {
		final.a = final.r * intensity;
	}
	
	COLOR = final.rgba;
}