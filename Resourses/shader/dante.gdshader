shader_type canvas_item;

uniform float radius : hint_range(0.0, 2.0) = 0.8;
uniform float softness : hint_range(0.0, 1.0) = 0.4;
uniform vec4 vignette_color : source_color = vec4(0.0,0.0,0.0,0.85);

void fragment() {
    vec2 uv = UV;
    vec2 centered = uv * 2.0 - 1.0;   // -1..1, centrado
    float dist = length(centered);

    // Invertimos el smoothstep para que el centro quede claro
    float vig = 1.0 - smoothstep(radius, radius - softness, dist);

    // Oscurecemos bordes y dejamos el centro transparente
    COLOR = vec4(vignette_color.rgb, vig * vignette_color.a);
}
