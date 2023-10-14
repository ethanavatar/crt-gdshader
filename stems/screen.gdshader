shader_type canvas_item;

float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(15.5151, 42.2561))) * 12341.14122 * sin(TIME * 0.03));
}

float noise(vec2 uv) {
 	vec2 i = floor(uv);
    vec2 f = fract(uv);
    
    float a = random(i);
    float b = random(i + vec2(1.,0.));
	float c = random(i + vec2(0., 1.));
    float d = random(i + vec2(1.));
    
    vec2 u = smoothstep(0., 1., f);
    
    return mix(a,b, u.x) + (c - a) * u.y * (1. - u.x) + (d - b) * u.x * u.y; 
                     
}

float vignette(vec2 uv, float size, float smoothness, float edgeRounding) {
 	uv -= .5;
    uv *= size;
    float amount = sqrt(pow(abs(uv.x), edgeRounding) + pow(abs(uv.y), edgeRounding));
    amount = 1. - amount;
    return smoothstep(0., smoothness, amount);
}

float scanline(vec2 uv, float count) {
	return sin(uv.y * count);
}

vec4 crt_filter(vec2 uv, vec3 col) {
	float s = scanline(uv, 480);
	vec4 col2 = mix(vec4(col, 1.0), vec4(s), 0.05) * vignette(uv, 1.9, 0.4, 8.0);
	return mix(col2, vec4(noise(uv * 240.)), 0.05);
}

void fragment() {
	vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec3 col = 0.5 + 0.5 * cos(TIME + UV.xyx + vec3(0, 2, 4));
	
	COLOR = vec4(col, 1.0);
	COLOR = crt_filter(UV.xy, col);
}
