shader_type canvas_item;
render_mode unshaded;

void fragment() {
	vec4 screen = texture(SCREEN_TEXTURE, SCREEN_UV).rgba;
	float grey = screen.r * 0.3 + screen.g * 0.59 + screen.b * 0.11;
	screen.rgb = mix(screen.rgb, vec3(grey, grey, grey), 0.8);
	screen.a = texture(TEXTURE, UV).a;
	COLOR = screen;
}