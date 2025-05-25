extern number u_time;
extern vec3 u_color1;
extern vec3 u_color2;
extern vec2 u_speed;
extern number u_angle;
extern number u_scale;
extern number u_aspect;

const float PI = 3.14159265359;

vec4 effect(vec4 vcolor, Image tex, vec2 texcoord, vec2 screenpos)
{
    float angle = u_angle * PI / 180.0;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    
    vec2 size = vec2(u_scale);
    vec2 p = (screenpos + u_time * u_speed) * vec2(u_aspect, 1.0);
    p = p * rot;

    float total = floor(p.x * size.x) + floor(p.y * size.y);
    bool isEven = mod(total, 2.0) == 0.0;

    vec4 col1 = vec4(u_color1 / 255.0, 1.0);
    vec4 col2 = vec4(u_color2 / 255.0, 1.0);

    return isEven ? col1 : col2;
}