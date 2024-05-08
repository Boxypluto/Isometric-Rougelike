shader_type canvas_item;

uniform float XSpeed;
uniform float YSpeed;
uniform vec4 ColorChoice;

void fragment(){
	vec2 newuv = UV;
	newuv.x += TIME * XSpeed;
	newuv.y += TIME * YSpeed;
	vec4 c = texture(TEXTURE, newuv);
	vec4 col = vec4(ColorChoice.x, ColorChoice.y, ColorChoice.z, clamp(c.a-ColorChoice.w, 0, 1));
	COLOR = col;
}