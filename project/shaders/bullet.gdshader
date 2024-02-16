shader_type canvas_item;

uniform sampler2D noise;
uniform float step_limit: hint_range(0.0, 1.0, 0.005) = 0.5;
uniform float blend_value: hint_range(0.0, 1.0, 0.005) = 0.4;

void fragment() {
	// Place fragment code here.
	NORMAL = texture(noise, UV).rgb;
	vec4 noise_blend = vec4(smoothstep(step_limit - blend_value, step_limit, NORMAL.rgb), 1.0);
	vec4 final_result = vec4(mix(texture(TEXTURE, UV), noise_blend, 1.0).rgb, step(0.1, texture(TEXTURE, UV).a));
	COLOR = final_result;
}
