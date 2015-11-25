//
//  TextureViewController.m
//  PictureFold
//
//  Created by 齐建琼 on 15/11/23.
//  Copyright © 2015年 齐建琼. All rights reserved.
//

#import "TextureViewController.h"
#import "AGLContext.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AGLKTextureLoader.h"

typedef struct{
    GLKVector3 positionCoords;   //空间坐标
    GLKVector2 textureCoords;    //纹理坐标
}SceneVertex;

static const SceneVertex vertices[]=
{
    {{-1.0f,-0.5f, 0.0f},{ 0.0f, 0.0f}},
    {{ 1.0f,-0.5f, 0.0f},{ 1.0f, 0.0f}},
    {{-1.0f, 0.5f, 0.0f},{ 0.0f, 1.0f}},
    {{ 1.0f,-0.5f, 0.0f},{ 1.0f, 0.0f}},
    {{ 1.0f, 0.5f, 0.0f},{ 1.0f, 1.0f}},
    {{-1.0f, 0.5f, 0.0f},{ 0.0f, 1.0f}},
    {{-0.5f, 0.5f, 0.0f},{ 0.0f, 0.0f}},
};

enum{
    WW,
    WL,
    NUM_UNIFORMS
};

GLuint uniform[NUM_UNIFORMS];

@interface GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID
                   value:(GLint)value;

@end


@implementation GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID
                   value:(GLint)value;
{
    glBindTexture(self.target, self.name);
    
    glTexParameteri(
                    self.target,
                    parameterID, 
                    value);
}

@end


@interface TextureViewController ()
- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation TextureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"view is not a GLKView");
    
    view.context = [[AGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLContext setCurrentContext:view.context];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self loadShaders];
    
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_FALSE;
//    self.baseEffect.constantColor = GLKVector4Make(0.5f, 0.5f, 0.5f, 1.0f);
    
    glEnable(GL_DEPTH_TEST);
    
    ((AGLContext *)view.context).aClearColor = GLKVector4Make(0.65f, 0.65f, 0.65f, 1.0f);
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStribe:sizeof(SceneVertex)
                         numberOfVertices:sizeof(vertices)
                         data:vertices
                         usage:GL_STATIC_DRAW];
 

#pragma mark - 设置纹理
    CGImageRef imageRef =
    [[UIImage imageNamed:@"1_AXIAL0.png"] CGImage];
    
    AGLKTextureInfo *textureInfo = [AGLKTextureLoader
                                    textureWithCGImage:imageRef
                                    options:nil
                                    error:NULL];
    
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_WRAP_S
                                           value:GL_CLAMP_TO_EDGE];
    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_WRAP_T
                                           value:GL_CLAMP_TO_EDGE];
#pragma mark -
}

- (void)update{
    float _ww,_wl;
    _wl=(-500.0+32767)/65535.0;
    _ww=(1200.0+32767)/65535.0;
    glUniform1f(uniform[WW], _ww);
    glUniform1f(uniform[WL], _wl);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
//    [self.baseEffect prepareToDraw];
    
    [(AGLContext *)view.context clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];
    
    [self.vertexBuffer
     prepareToDrawWithAttrib:GLKVertexAttribPosition
     numberOfCoordinates:3
     attribOffset:offsetof(SceneVertex, positionCoords)
     shouldEnable:YES];
    
    [self.vertexBuffer
     prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
     numberOfCoordinates:2
     attribOffset:offsetof(SceneVertex, textureCoords)
     shouldEnable:YES];
    
    [self.vertexBuffer
     drawArrayWithMode:GL_TRIANGLES
     startVertexIndex:0
     numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)];
    
    glUseProgram(_program);
    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertices)/sizeof(SceneVertex));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)loadShaders{
    GLuint vShader,fShader;
    NSString *vertShaderPathname, *fragShaderPathname;

    _program = glCreateProgram();
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    
    if (![self compileShader:&vShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    if (![self compileShader:&fShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    glAttachShader(_program, vShader);
    glAttachShader(_program, fShader);
    
    glBindAttribLocation(_program, GLKVertexAttribPosition, "aPosition");
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "aTextureCoord0");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        if (vShader) {
            glDeleteShader(vShader);
            vShader = 0;
        }
        if (fShader) {
            glDeleteShader(fShader);
            fShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        return NO;
    }
    
    uniform[WW] = glGetUniformLocation(_program, "ww");
    uniform[WL] = glGetUniformLocation(_program, "wl");
    
    if (vShader) {
        glDetachShader(_program, vShader);
        glDeleteShader(vShader);
    }
    if (fShader) {
        glDetachShader(_program, fShader);
        glDeleteShader(fShader);
    }
    
    return YES;
}


- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }

    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
 
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (void)dealloc{
    GLKView *view = (GLKView *)self.view;
    [AGLContext setCurrentContext:view.context];
    
    self.vertexBuffer = nil;
    
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}

@end
