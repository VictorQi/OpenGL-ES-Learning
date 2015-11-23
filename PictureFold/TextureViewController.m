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

typedef struct{
    GLKVector3 positionCoords;   //空间坐标
    GLKVector2 textureCoords;    //纹理坐标
}SceneVertex;

static const SceneVertex vertices[]=
{
    {{-0.5f, -0.5f, 0.0f},{0.0f, 1.0f}},   //左下角
    {{ 0.5f, -0.5f, 0.0f},{1.0f, 0.0f}},   //右下角
    {{-0.5f,  0.5f, 0.0f},{0.0f, 0.0f}},   //左上角
};

@interface TextureViewController ()

@end

@implementation TextureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"view is not a GLKView");
    
    view.context = [[AGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(0.5f, 0.5f, 0.5f, 1.0f);
    
    ((AGLContext *)view.context).aClearColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStribe:sizeof(SceneVertex)
                         numberOfVertices:sizeof(vertices)
                         data:vertices
                         usage:GL_STATIC_DRAW];
 

#pragma mark - 设置纹理
    CGImageRef imageRef = [UIImage imageNamed:@"aodamiao.png"].CGImage;
    
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:NULL];
    
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
#pragma mark -
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    [(AGLContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
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
     numberOfVertices:3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
