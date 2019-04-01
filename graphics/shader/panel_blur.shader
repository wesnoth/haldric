shader_type canvas_item;

uniform float blur : hint_range(0.0, 5.0);

void fragment() {
	vec4 screen = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur);
	vec4 panel = texture(TEXTURE, UV);
	vec4 final = mix(screen, panel, 0.5);
	final.a = panel.a * 2.0;
	COLOR = final;
}