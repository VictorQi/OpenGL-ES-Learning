//
//  AGLKView.m
//  PictureFold
//
//  Created by 齐建琼 on 15/11/20.
//  Copyright © 2015年 齐建琼. All rights reserved.
//

#import "AGLKView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AGLKView
@synthesize delegate;
@synthesize context;

+ (Class)layerClass{
    return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame context:(EAGLContext *)aContext
{
    self = [super initWithFrame:frame];
    if (self) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.drawableProperties =
        [NSDictionary dictionaryWithObjectsAndKeys:
         [NSNumber numberWithBool:NO],
         kEAGLDrawablePropertyRetainedBacking,
         kEAGLColorFormatRGBA8,
         kEAGLDrawablePropertyColorFormat,
         nil];
        self.context = context;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.drawableProperties =
        [NSDictionary dictionaryWithObjectsAndKeys:
         [NSNumber numberWithBool:NO],
         kEAGLDrawablePropertyRetainedBacking,
         kEAGLColorFormatRGBA8,
         kEAGLDrawablePropertyColorFormat,
         nil];
    }
    return self;
}

- (void)setContext:(EAGLContext *)aContext
{
    if (context != aContext) {
        [EAGLContext setCurrentContext:context];
        
        if (defaultFrameBuffer != 0) {
            glDeleteFramebuffers(1, &defaultFrameBuffer);
            defaultFrameBuffer = 0;
        }
        
        if (colorRenderBuffer != 0) {
            glDeleteRenderbuffers(1, &colorRenderBuffer);
            colorRenderBuffer = 0;
        }
        
        context = aContext;
        
        if (context != nil) {
            context = aContext;
            [EAGLContext setCurrentContext:context];
            
            glGenFramebuffers(1, &defaultFrameBuffer);
            glBindFramebuffer(GL_FRAMEBUFFER, defaultFrameBuffer);
            
            glGenRenderbuffers(1, &colorRenderBuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
            
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBuffer);
        }
    }
}

- (EAGLContext *)context{
    return context;
}

- (void)display{
    [EAGLContext setCurrentContext:self.context];
    glViewport(0, 0, self.drawableWidth, self.drawableHeight);
    [self drawRect:[self bounds]];
    
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)drawRect:(CGRect)rect{
    if (self.delegate) {
        [self.delegate glkView:self drawInRect:rect];
    }
}

- (void)layoutSubviews{
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
    
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"failed to make complete buffer object %x",status);
    }
}

- (NSInteger)drawableWidth{
    GLint backingWidth;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    return (NSInteger)backingWidth;
}

- (NSInteger)drawableHeight{
    GLint backingHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingHeight);
    return (NSInteger)backingHeight;
}

- (void)dealloc{
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    context = nil;
}
@end
