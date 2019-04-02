shader_type canvas_item;
render_mode unshaded;

uniform float brightness : hint_range(0.0, 2.0, 0.05);
uniform float saturation : hint_range(0.0, 1.0, 0.1);
uniform float contrast : hint_range(1.0, 2.0, 0.1);
uniform float blur : hint_range(0.0, 5.0, 0.1);

void fragment() {
	
	vec4 screen = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur).rgba;
	screen.a = texture(TEXTURE, UV).a;
	
	float grey = screen.r * 0.3 + screen.g * 0.59 + screen.b * 0.11;
	
	// saturation
	screen.rgb = mix(vec3(grey, grey, grey), screen.rgb, saturation);
	
	// contrast
	screen.rgb = ((screen.rgb - 0.5) * max(contrast, 0)) + 0.5;
	
	// brightness
	screen.rgb = screen.rgb * brightness;

	COLOR = screen;
}