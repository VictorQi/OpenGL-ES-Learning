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
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStribe:sizeof(SceneVertex)
                         numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)
                         data:vertices
                         usage:GL_STATIC_DRAW];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
