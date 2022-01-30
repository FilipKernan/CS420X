float numOfTeeth = 16.;
float effectTimeMix = .1;
float rotationEffectmax = .9;

vec3 gear(float a, float r, vec3 startColor) {
    float f = smoothstep(-.5,1., sin(a*numOfTeeth))*0.2+0.5;
    vec3 color = 1.*vec3( 1.-smoothstep(f,f+0.02,r) )* startColor - vec3( 1.-smoothstep(f,f+0.02,r*1.15) );
    return color;
}
float timeMix(float start, float end, float rate){
    return mix(start, end, fract(rate*mod(time, 10.)));
}

void main(){
    vec2 st = uv();
    st.x = abs(st.x);
    st.y = abs(st.y);
    vec3 color = hsv2rgb(vec3(timeMix(0., 1., .2), .75, .75));




    if (mod(time, 60.) < 10.) {
        vec2 pos = vec2(0.5)-st;

        float r = length(pos)*(52. - timeMix(2., 50., effectTimeMix));
        float a = atan(pos.y ,pos.x);
        float f = smoothstep(-.5,1., sin(a*numOfTeeth)* cos(PI*time))*0.2+0.5;
        color = 1.*vec3( 1.-smoothstep(f,f+0.02,r) )* color - vec3( 1.-smoothstep(f,f+0.02,r*1.15) );
        gl_FragColor = vec4(color, 1.0);
    } else if (mod(time, 60.) < 20.) {
        vec2 pos = vec2(0.5)-st;

        float r = length(pos)*(52. - timeMix(2., 50., effectTimeMix));
        float a = atan(pos.y ,pos.x);
        float f = smoothstep(-.5,1., sin(a*numOfTeeth)* cos(PI*time))*0.2+0.5;
        vec3 gearColor = 1.*vec3( 1.-smoothstep(f,f+0.02,r) )* color - vec3( 1.-smoothstep(f,f+0.02,r*1.15) );
        pos = vec2(0.5)-st;
        pos = rotate(vec2(0, 0), pos, pow(mod(time, 10.), 2.2)*.01 * PI);

        r = length(pos)*2.0;
        a = atan(pos.y ,pos.x);
        color = gear(a, r, color);
        gl_FragColor = vec4(color, 1.0) + vec4(gearColor, 1.0);
    } else if (mod(time, 60.) < 30.) {
        vec2 pos = vec2(0.5)-st;

        float r = length(pos)*2.;
        float a = atan(pos.y ,pos.x);
        float f = smoothstep(-.5,1., sin(a*numOfTeeth)* cos(PI*time))*0.2+0.5;
        vec3 gearColor = 1.*vec3( 1.-smoothstep(f,f+0.02,r) )* color - vec3( 1.-smoothstep(f,f+0.02,r*1.15) );
        pos = vec2(0.5)-st;
        pos = rotate(vec2(0, 0), pos, time* PI *.5);

        r = length(pos)*2.0;
        a = atan(pos.y ,pos.x);
        color = gear(a, r, color);
        gl_FragColor = vec4(color, 1.0) + vec4(gearColor, 1.0);
    } else if (mod(time, 60.) < 40.) {
        vec2 pos = vec2(0.5)-st;

        float r = length(pos)*timeMix(2., .05, effectTimeMix);
        float a = atan(pos.y ,pos.x);
        float f = smoothstep(-.5,1., sin(a*numOfTeeth)* cos(PI*time))*0.2+0.5;
        vec3 gearColor = 1.*vec3( 1.-smoothstep(f,f+0.02,r) )* color - vec3( 1.-smoothstep(f,f+0.02,r*1.15) );

        pos = vec2(0.5)-st;
        pos = rotate(vec2(0, 0), pos,  time* PI *.5);

        r = length(pos)*2.0;
        a = atan(pos.y ,pos.x);
        color = gear(a, r, color);
        vec4 lastFrame = texture2D(backbuffer, st);

        gl_FragColor = vec4(color, 1.0) + lastFrame * timeMix(-0.1, rotationEffectmax, effectTimeMix) + vec4(gearColor, 1.0);

    } else if (mod(time, 60.) < 50.) {
        vec2 pos = vec2(0.5)-st;
        pos = rotate(vec2(0, 0), pos,  time* PI *.5);

        float r = length(pos)*2.0;
        float a = atan(pos.y ,pos.x);
        color = gear(a, r, color);
        vec4 rotationEffect = texture2D(backbuffer, st);

        vec4 lastFrame = texture2D(backbuffer, st + vec2(-0.5 * timeMix(0.2, 1., effectTimeMix), 0.5* timeMix(0.2, 1., effectTimeMix)))
            + texture2D(backbuffer, st - vec2(0.05 * timeMix(0.2, 1., effectTimeMix), 0.05* timeMix(0.2, 1., effectTimeMix)));

        gl_FragColor = vec4(color, 1.0)+ rotationEffect * rotationEffectmax + lastFrame * timeMix(0., .5, effectTimeMix/2.);

    } else if (mod(time, 60.) < 60.) {
        vec2 pos = vec2(0.5)-st;
        pos = pos/timeMix(1.,  8., .05);
        pos = rotate(vec2(0, 0), pos,  time* PI *.5);

        float r = length(pos)*2.0;
        float a = atan(pos.y ,pos.x);
        color = gear(a, r, color);

        vec4 rotationEffect = texture2D(backbuffer, st);

        vec4 lastFrame = texture2D(backbuffer, st + vec2(-0.5, 0.5)) + texture2D(backbuffer, st - vec2(0.1 , 0.1));

        gl_FragColor = (vec4(color, 1.0)+ rotationEffect * timeMix(rotationEffectmax, 0., effectTimeMix) + lastFrame * 0.5) * min(1., timeMix(2., -0.001, effectTimeMix));
    }

}
