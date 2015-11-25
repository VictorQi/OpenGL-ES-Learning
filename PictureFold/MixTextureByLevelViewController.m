//
//  MixTextureByLevelViewController.m
//  PictureFold
//
//  Created by 齐建琼 on 15/11/24.
//  Copyright © 2015年 齐建琼. All rights reserved.
//

#import "MixTextureByLevelViewController.h"
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

@interface MixTextureByLevelViewController ()
@property (strong, nonatomic) GLKTextureInfo *textureInfo1;
@property (strong, nonatomic) GLKTextureInfo *textureInfo2;
@end

@implementation MixTextureByLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"view is not a glkview");
    
    view.context = [[AGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(0.7f, 0.8f, 0.9f, 1.0);
    
    ((AGLContext *)view.context).aClearColor = GLKVector4Make(0.5f, 0.4f, 0.3f, 1.0f);
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]initWithAttribStribe:sizeof(SceneVertex)
                                                                numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)
                                                                            data:vertices
                                                                           usage:GL_STATIC_DRAW];
    
    CGImageRef imageRef1 = [UIImage imageNamed:@"leaves.gif"].CGImage;
    CGImageRef imageRef2 = [UIImage imageNamed:@"beetle.png"].CGImage;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil];
    
    
    GLKTextureInfo *textureInfo1 = [GLKTextureLoader textureWithCGImage:imageRef1 options:dict error:NULL];
    
    GLKTextureInfo *textureInfo2 = [GLKTextureLoader textureWithCGImage:imageRef2 options:dict error:NULL];
    
    self.baseEffect.texture2d0.name = textureInfo1.name;
    self.baseEffect.texture2d0.target = textureInfo1.target;
    
    self.baseEffect.texture2d1.name = textureInfo2.name;
    self.baseEffect.texture2d1.target = textureInfo2.target;
    self.baseEffect.texture2d1.envMode = GLKTextureEnvModeDecal;
    
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
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord1
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    
    [self.baseEffect prepareToDraw];
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)];
    
}

- (void)dealloc{
    GLKView *view = (GLKView *)self.view;
    [AGLContext setCurrentContext:view.context];
    
    self.vertexBuffer = nil;
    
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}

@end

