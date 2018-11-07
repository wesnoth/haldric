shader_type canvas_item;
render_mode unshaded;

uniform sampler2D mask : hint_albedo;
// uniform sampler2D details : hint_albedo;

void fragment() {
	vec4 base = texture(TEXTURE, UV).rgba;
	base.a = texture(mask, UV).a;
	
	COLOR = base;
	// vec4 detail = texture(details, UV).rgba;
	// float alpha = detail.a + texture(mask, UV).a;
	// COLOR = vec4((detail.rgb * detail.a) + (base.rgb * (1.0 - detail.a)), alpha);
}