shader_type canvas_item;

uniform sampler2D noise;
uniform float step_limit: hint_range(0.0, 1.0, 0.005) = 0.5;
uniform float blend_value: hint_range(0.0, 1.0, 0.005) = 0.4;
uniform float mix_value: hint_range(0.0, 1.0, 0.005) = 0.5;
uniform float subtract: hint_range(0.0, 1.0, 0.005) = 1.0;

void fragment() {
	// Place fragment code here.
	vec4 tex = texture(TEXTURE, UV);
	NORMAL = texture(noise, UV).rgb;
	vec4 noise_blend = vec4(smoothstep(step_limit - blend_value, step_limit, NORMAL.rgb), 1.0);
	vec4 s1 = vec4(mix(texture(TEXTURE, UV), noise_blend, 1.0).rgb, step(0.1, texture(TEXTURE, UV).a));
	//s1.a = step(0.2, s1.r);
	COLOR = vec4(tex.rgb * s1.rgb, 1.0) - vec4(subtract, subtract, subtract, 0.0);
	//COLOR = mix(tex, final_result, mix_value);
}

