shader_type canvas_item;

uniform float speed;
uniform float density : hint_range(0.1, 2.0);
uniform sampler2D noise : hint_albedo;

void fragment() {
	vec4 cover = texture(TEXTURE, UV);

	vec4 n = texture(noise, UV + TIME * speed);
	vec4 n2 = texture(noise, vec2(UV.y, UV.x) - TIME * speed);

	if (cover.r > 0.0) {
		cover.a = 1.0 - cover.r;
		cover.rgb = vec3(0.0, 0.0, 0.0);
	}

	vec4 final = mix(n, n2, 0.5);

	final.a = cover.a;

	if (final.a > 0.0) {
		final.a = min(final.a, final.r);
		final.a = min(final.a, final.r) * density;
		final.r = final.r * 0.92
	}

	COLOR = final;
}
