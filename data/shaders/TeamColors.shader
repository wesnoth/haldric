shader_type canvas_item;
render_mode unshaded;
uniform vec4 color1;
uniform vec4 color2;
uniform vec4 color3;
uniform vec4 color4;
uniform vec4 color5;
uniform vec4 color6;
uniform vec4 color7;
uniform vec4 color8;
uniform vec4 color9;
uniform vec4 color10;
uniform vec4 color11;
uniform vec4 color12;
uniform vec4 color13;
uniform vec4 color14;
uniform vec4 color15;
uniform vec4 color16;
uniform vec4 color17;
uniform vec4 color18;
uniform vec4 color19;

uniform vec4 base1;
uniform vec4 base2;
uniform vec4 base3;
uniform vec4 base4;
uniform vec4 base5;
uniform vec4 base6;
uniform vec4 base7;
uniform vec4 base8;
uniform vec4 base9;
uniform vec4 base10;
uniform vec4 base11;
uniform vec4 base12;
uniform vec4 base13;
uniform vec4 base14;
uniform vec4 base15;
uniform vec4 base16;
uniform vec4 base17;
uniform vec4 base18;
uniform vec4 base19;

void fragment() {
	vec4 curr_color = texture(TEXTURE,UV);
	if (curr_color == base1) {
		COLOR = color1;
	}
	else if (curr_color == base2) {
		COLOR = color2;
	}
	else if (curr_color == base3) {
		COLOR = color3;
	}
	else if (curr_color == base4) {
		COLOR = color4;
	}
	else if (curr_color == base5) {
		COLOR = color5;
	}
	else if (curr_color == base6) {
		COLOR = color6;
	}
	else if (curr_color == base7) {
		COLOR = color7;
	}
	else if (curr_color == base8) {
		COLOR = color8;
	}
	else if (curr_color == base9) {
		COLOR = color9;
	}
	else if (curr_color == base10) {
		COLOR = color10;
	}
	else if (curr_color == base11) {
		COLOR = color11;
	}
	else if (curr_color == base12) {
		COLOR = color12;
	}
	else if (curr_color == base13) {
		COLOR = color13;
	}
	else if (curr_color == base14) {
		COLOR = color14;
	}
	else if (curr_color == base15) {
		COLOR = color15;
	}
	else if (curr_color == base16) {
		COLOR = color16;
	}
	else if (curr_color == base17) {
		COLOR = color17;
	}
	else if (curr_color == base18) {
		COLOR = color18;
	}
	else if (curr_color == base19) {
		COLOR = color19;
	} else {
		COLOR = curr_color;
	}
}