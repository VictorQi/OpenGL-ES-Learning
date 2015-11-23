//
//  OpenGLViewController.m
//  PictureFold
//
//  Created by 齐建琼 on 15/11/20.
//  Copyright © 2015年 齐建琼. All rights reserved.
//

#import "OpenGLViewController.h"

typedef struct {
    GLKVector3 positionCoords;
}SceneVertex;

static const SceneVertex vertices[] =
{
    {{-0.5f,-0.5f,0.0f}},    //左下角
    {{ 0.5f,-0.5f,0.0f}},    //右下角
    {{-0.5f, 0.5f,0.0f}},    //左上角
};

@interface OpenGLViewController ()
@property (nonatomic, strong) GLKView *drawView;
@end

@implementation OpenGLViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _drawView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    
    _drawView = [[GLKView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20) context:[[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2]];
    
//    GLKView *view = (GLKView *)self.view;
    self.view = _drawView;
//    UIView *tmpView = [[UIView alloc]initWithFrame:_drawView.frame];
//    tmpView = _drawView;
//    [self.view addSubview:tmpView];
    
    NSAssert([_drawView isKindOfClass:[GLKView class]], @"view controller's view isn't a GLKView class");
    
//    view.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:_drawView.context];
    
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);  //就是他喵的白色 r,g,b,a
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);  //背景色 他喵的黑的
    
    glGenBuffers(1, &vertextBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vertextBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SceneVertex),
                          NULL);
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
//    GLKView *view = (GLKView *)_drawView;
    [EAGLContext setCurrentContext:_drawView.context];
    
    if (0 != vertextBufferID) {
        glDeleteBuffers(1, &vertextBufferID);
        vertextBufferID = 0;
    }
    
//    ((GLKView *)self.view).context = nil;
    _drawView.context = nil;
    [EAGLContext setCurrentContext:nil];
}

@end
