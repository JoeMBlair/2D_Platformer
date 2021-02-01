shader_type canvas_item;
render_mode blend_mix;

uniform vec4 new_overalls:hint_color;
uniform vec4 new_shirt:hint_color;
uniform vec4 new_skin:hint_color;

vec4 trunc_vec(vec4 v, float n){
    v.x=floor(pow(10,n) * v.x) / pow(10,n);
    v.y=floor(pow(10,n) * v.x) / pow(10,n);
    v.z=floor(pow(10,n) * v.x) / pow(10,n);
    return v;
}
 

void fragment(){
    vec4 color = texture(TEXTURE, UV);

	if (color.r > 0.9 && color.r < 1.1 && color.a == 1.0) { 
        color = new_skin;
    }
	if (color.r > 0.5 && color.r < 0.6 && color.a == 1.0) { 
        color = new_shirt;
    }
	if (color.r > 0.3 && color.r < 0.4 && color.a == 1.0) {
		color = new_overalls;
	}
	
    COLOR = color;
}

