//
//  Shader.fsh
//  
//

/////////////////////////////////////////////////////////////////
// UNIFORMS
/////////////////////////////////////////////////////////////////
uniform sampler2D uSampler0;

uniform highp float ww;  //窗宽
uniform highp float wl;  //窗位

/////////////////////////////////////////////////////////////////
// Varyings
/////////////////////////////////////////////////////////////////
varying highp vec2 vTextureCoord0;


void main()
{
//    if (ww>-499.0) {
//        gl_FragColor = vec4(1.0,0.0,0.0,0.0);
//        return;
//    }
    highp float delta = 32767.0/65535.0;
    
    highp vec4 color0 = texture2D(uSampler0, vTextureCoord0);
    
    highp float color=color0.x-delta;
    
    highp float ww0=ww-delta;
    highp float wl0=wl-delta;
    
    
    
    highp float pixel=1.0;
    
    if (color<(wl0-ww0*0.5)) {
        pixel = 0.0;
    }
    else if (color>(wl0+ww0*0.5))
    {
        pixel = 1.0;
    }
    else
    {
        pixel = (color-wl0+ww0*0.5)/ww0;
//        pixel=0.3;
    }

//    if (ww0>/65535.0) {
//        pixel=0.5;
//    }
    
    
    gl_FragColor = vec4(pixel,pixel,pixel,0.0);
}
