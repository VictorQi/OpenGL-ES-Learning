//
//  TextureChangedViewController.m
//  PictureFold
//
//  Created by 齐建琼 on 15/11/23.
//  Copyright © 2015年 齐建琼. All rights reserved.
//

#import "TextureChangedViewController.h"
#import "AGLContext.h"
#import "AGLKVertexAttribArrayBuffer.h"

#pragma mark - GLKEffectPropertyTexture的类category
@interface GLKEffectPropertyTexture (AKGLAdditions)

- (void)AGLKSetParameters:(GLenum)parameterID value:(GLint)value;

@end

@implementation GLKEffectPropertyTexture (AKGLAdditions)

- (void)AGLKSetParameters:(GLenum)parameterID value:(GLint)value
{
    glBindTexture(self.target, self.name);
    
    glTexParameteri(self.target, parameterID, value);
}

@end


#pragma mark - 
#pragma mark TextureChangedViewController的真正实现

typedef struct{
    GLKVector3 positionCoords;
    GLKVector3 textureCoords;
}SceneVertex;

static SceneVertex vertices[] =
{
    {{-0.5f,-0.5f, 0.0f},{ 0.0f, 0.0f}},
    {{ 0.5f,-0.5f, 0.0f},{ 1.0f, 0.0f}},
    {{-0.5f, 0.5f, 0.0f},{ 0.0f, 1.0f}},
};

static const SceneVertex defaultVertices[] =
{
    {{-0.5f,-0.5f, 0.0f},{ 0.0f, 0.0f}},
    {{ 0.5f,-0.5f, 0.0f},{ 1.0f, 0.0f}},
    {{-0.5f, 0.5f, 0.0f},{ 0.0f, 1.0f}},
};

// Provide storage for the vectors that control the direction
// and distance that each vertex moves per update when animated
static GLKVector3 movementVectors[3] = {
    {-0.02f,  -0.01f, 0.0f},
    {0.01f,  -0.005f, 0.0f},
    {-0.01f,   0.01f, 0.0f},
};

@interface TextureChangedViewController ()

@end

@implementation TextureChangedViewController

- (void)updateTextureParameter{
    [self.baseEffect.texture2d0
     AGLKSetParameters:GL_TEXTURE_WRAP_S
     value:self.shouldRepeatTexture?GL_REPEAT:GL_CLAMP_TO_EDGE];
    
    [self.baseEffect.texture2d0
     AGLKSetParameters:GL_TEXTURE_MAG_FILTER
     value:self.shouldUseLinearFilter?GL_LINEAR:GL_NEAREST];
}

- (void)updateAnimatedVertexPosition{
    if(self.shouldAnimating)
    {
        int i;
        for (i = 0; i < 3; i++)
        {
            vertices[i].positionCoords.x += movementVectors[i].x;
            if (vertices[i].positionCoords.x >=  1.0 ||
                vertices[i].positionCoords.x <= -1.0)
            {
                movementVectors[i].x = -movementVectors[i].x;
            }
            vertices[i].positionCoords.y += movementVectors[i].y;
            if (vertices[i].positionCoords.y >=  1.0 ||
                vertices[i].positionCoords.y <= -1.0)
            {
                movementVectors[i].y = -movementVectors[i].y;
            }
            vertices[i].positionCoords.z += movementVectors[i].z;
            if (vertices[i].positionCoords.z >=  1.0 ||
                vertices[i].positionCoords.z <= -1.0)
            {
                movementVectors[i].z = -movementVectors[i].z;
            }
        }
    }else
    {
        //复原顶点位置
        for (int i = 0; i < 3; i++) {
            vertices[i].positionCoords.x = defaultVertices[i].positionCoords.x;
            vertices[i].positionCoords.y = defaultVertices[i].positionCoords.y;
            vertices[i].positionCoords.z = defaultVertices[i].positionCoords.z;
        }
    }
    
    //调整纹理的s坐标来滑动纹理
    {
        int i;
        for (i = 0; i < 3; i++) {
            vertices[i].textureCoords.s =
            (defaultVertices[i].textureCoords.s +
             self.sCoordinateOffse);
        }
    }
}

- (void)update{
    [self updateAnimatedVertexPosition];
    [self updateTextureParameter];
    [self.vertexBuffer
     reinitWithAttribStride:sizeof(SceneVertex)
     numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)
     bytes:vertices];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.preferredFramesPerSecond = 60;  //动画每秒60帧
    self.shouldAnimating = YES;
    self.shouldRepeatTexture = YES;
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"view is not glkview");
    
    view.context = [[AGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.f, 1.f, 1.f, 1.0f);
    
    ((AGLContext *)view.context).aClearColor = GLKVector4Make(0.f, 0.f, 0.f, 1.0f);
    
    self.vertexBuffer =
    [[AGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStribe:sizeof(SceneVertex)
                         numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)
                         data:vertices
                         usage:GL_DYNAMIC_DRAW];
    
    CGImageRef imageRef = [UIImage imageNamed:@"grid.png"].CGImage;
    
    GLKTextureInfo *textureInfo = [GLKTextureLoader
                                   textureWithCGImage:imageRef
                                   options:nil
                                   error:NULL];

    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];

    [(AGLContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:YES];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:YES];
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:3];
}

- (IBAction)takeSCoordsOffset:(UISlider *)sender {
    self.sCoordinateOffse = sender.value;
}

- (IBAction)takeLinearFilter:(UISwitch *)sender {
    self.shouldUseLinearFilter = [sender isOn];
}

- (IBAction)takeAnimation:(UISwitch *)sender {
    self.shouldAnimating = [sender isOn];
}

- (IBAction)takeRepeat:(UISwitch *)sender {
    self.shouldRepeatTexture = [sender isOn];
}

- (void)dealloc{
    GLKView *view = (GLKView *)self.view;
    [AGLContext setCurrentContext:view.context];
    
    self.vertexBuffer = nil;
    
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}

@end
