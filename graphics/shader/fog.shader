shader_type canvas_item;

uniform sampler2D noise : hint_albedo;
uniform vec2 offset;

void fragment() {
	vec4 map = texture(TEXTURE, UV);
	vec2 coord = SCREEN_UV;
	
	vec4 n = texture(noise, coord + TIME * 0.01);
	vec4 n2 = texture(noise, vec2(coord.y, coord.x) - TIME * 0.01);
	
	vec4 final = mix(n, n2, 0.5);
	
	final.a = map.a;
	
	if (final.a > 0.0) {
		final.a = final.r;
	}
	
	COLOR = final.rgba;
}