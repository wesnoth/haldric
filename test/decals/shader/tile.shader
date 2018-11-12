shader_type canvas_item;
render_mode unshaded;

uniform sampler2D base_mask : hint_albedo;

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

uniform sampler2D tex6 : hint_black_albedo;
uniform sampler2D mask6 : hint_albedo;

vec4 overlay(vec4 base, vec4 transition, float alpha) {
	if (transition.rgb != vec3(0.0, 0.0, 0.0)) {
		if (alpha == 0.0) {
			transition.a = 0.0;
		}	
		return vec4((transition.rgb * transition.a) + (base.rgb * (1.0 - transition.a)), base.a);
	}
	return base;
}

uniform vec2 size;
uniform vec2 scale;
uniform vec2 position;
uniform vec2 region;

vec2 uv(vec2 uv) {
	vec2 s = vec2(size.x / scale.x, size.x / scale.y);
	vec2 p = vec2(position.x / (size.x / s.x), position.y / (size.y / s.y));
	return vec2(uv.x * s.x - p.x, uv.y * s.y - p.y);
}

void fragment() {
	vec4 base = texture(TEXTURE, UV).rgba;
	
	base.a = texture(base_mask, uv(UV)).a;
	
	base = overlay(base, texture(tex1, uv(UV)).rgba, texture(mask1, uv(UV)).a);
	base = overlay(base, texture(tex2, uv(UV)).rgba, texture(mask2, uv(UV)).a);
	base = overlay(base, texture(tex3, uv(UV)).rgba, texture(mask3, uv(UV)).a);
	base = overlay(base, texture(tex4, uv(UV)).rgba, texture(mask4, uv(UV)).a);
	base = overlay(base, texture(tex5, uv(UV)).rgba, texture(mask5, uv(UV)).a);
	base = overlay(base, texture(tex6, uv(UV)).rgba, texture(mask6, uv(UV)).a);
	
	COLOR = base;
}