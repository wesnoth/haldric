shader_type canvas_item;
render_mode unshaded;

uniform sampler2D tex0 : hint_black_albedo;
uniform sampler2D mask0 : hint_albedo;

uniform sampler2D tex1 : hint_black_albedo;
uniform sampler2D mask1 : hint_albedo;

uniform sampler2D tex2 : hint_black_albedo;
uniform sampler2D mask2 : hint_albedo;

uniform sampler2D tex3 : hint_black_albedo;
uniform sampler2D mask3 : hint_albedo;

uniform sampler2D tex4 : hint_black_albedo;
uniform sampler2D mask4 : hint_albedo;

uniform sampler2D tex5 : hint_black_albedo;
uniform sampler2D mask5 : hint_albedo;

vec4 overlay(vec4 base, vec4 transition, float alpha) {
	if (transition.rgb != vec3(0.0, 0.0, 0.0)) {
		if (alpha == 0.0) {
			transition.a = 0.0;
		}
		return vec4((transition.rgb * transition.a) + (base.rgb * (1.0 - transition.a)), max(transition.a, base.a));
	}
	return base;
}

void fragment() {
	vec4 base = texture(TEXTURE, UV).rgba;
	
	base = overlay(base, texture(tex0, UV).rgba, texture(mask0, UV).r);
	base = overlay(base, texture(tex1, UV).rgba, texture(mask1, UV).r);
	base = overlay(base, texture(tex2, UV).rgba, texture(mask2, UV).r);
	base = overlay(base, texture(tex3, UV).rgba, texture(mask3, UV).r);
	base = overlay(base, texture(tex4, UV).rgba, texture(mask4, UV).r);
	base = overlay(base, texture(tex5, UV).rgba, texture(mask5, UV).r);
	
	COLOR = base;
}