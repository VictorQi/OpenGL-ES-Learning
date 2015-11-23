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
     AGLKSetParameters:GL_TEXTURE_MIN_FILTER
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
                vertices[i].positionCoords.x -= movementVectors[i].x;
            }
            vertices[i].positionCoords.y += movementVectors[i].y;
            if (vertices[i].positionCoords.y >=  1.0 ||
                vertices[i].positionCoords.y <= -1.0)
            {
                vertices[i].positionCoords.y -= movementVectors[i].y;
            }
            vertices[i].positionCoords.z += movementVectors[i].z;
            if (vertices[i].positionCoords.z >=  1.0 ||
                vertices[i].positionCoords.z <= -1.0)
            {
                vertices[i].positionCoords.z -= movementVectors[i].z;
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
            vertices[i].positionCoords.s = defaultVertices[i].positionCoords.s + self.sCoordinateOffse;
        }
    }
}

- (void)update{
    [self updateTextureParameter];
    [self updateAnimatedVertexPosition];
    [self.vertexBuffer
     reinitWithAttribStride:sizeof(vertices)
     numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)
     bytes:vertices];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
