//
//  MixTextureViewController.m
//  PictureFold
//
//  Created by 齐建琼 on 15/11/24.
//  Copyright © 2015年 齐建琼. All rights reserved.
//

#import "MixTextureViewController.h"
#import "AGLContext.h"
#import "AGLKVertexAttribArrayBuffer.h"

typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
}SceneVertex;

static const SceneVertex vertices[] =
{
    {{-1.0f,-0.5f, 0.0f},{ 0.0f, 0.0f}},
    {{ 1.0f,-0.5f, 0.0f},{ 1.0f, 0.0f}},
    {{-1.0f, 0.5f, 0.0f},{ 0.0f, 1.0f}},
    {{ 1.0f,-0.5f, 0.0f},{ 1.0f, 0.0f}},
    {{ 1.0f, 0.5f, 0.0f},{ 1.0f, 1.0f}},
    {{-1.0f, 0.5f, 0.0f},{ 0.0f, 1.0f}},
};


@interface MixTextureViewController ()
@property (strong, nonatomic) GLKTextureInfo *textureInfo1;
@property (strong, nonatomic) GLKTextureInfo *textureInfo2;
@end

@implementation MixTextureViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"view is not a glkview");
    
    view.context = [[AGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(0.7f, 0.8f, 0.9f, 1.0f);
    
    ((AGLContext *)view.context).aClearColor = GLKVector4Make(0.8f, 0.3f, 0.4f, 1.0f);
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStribe:sizeof(SceneVertex) numberOfVertices:sizeof(vertices)/sizeof(SceneVertex) data:vertices usage:GL_DYNAMIC_DRAW];
    
    CGImageRef imageRef1 = [UIImage imageNamed:@"leaves.gif"].CGImage;
    CGImageRef imageRef2 = [UIImage imageNamed:@"beetle.png"].CGImage;
    
    self.textureInfo1 = [GLKTextureLoader
                                    textureWithCGImage:imageRef1
                                    options:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:YES],
                                     GLKTextureLoaderOriginBottomLeft, nil]
                                    error:NULL];
    self.textureInfo2 = [GLKTextureLoader
                                    textureWithCGImage:imageRef2
                                    options:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:YES],
                                     GLKTextureLoaderOriginBottomLeft, nil]
                                    error:NULL];
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_COLOR);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [(AGLContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, positionCoords)
                                  shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    
    self.baseEffect.texture2d0.name = self.textureInfo1.name;
    self.baseEffect.texture2d0.target = self.textureInfo1.target;
    [self.baseEffect prepareToDraw];
    
    // Draw triangles using the vertices in the
    // currently bound vertex buffer
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)];
    
    self.baseEffect.texture2d0.name = self.textureInfo2.name;
    self.baseEffect.texture2d0.target = self.textureInfo2.target;
    [self.baseEffect prepareToDraw];
    
    // Draw triangles using currently bound vertex buffer
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)];
    
}

@end
