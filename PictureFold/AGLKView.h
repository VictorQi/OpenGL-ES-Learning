//
//  AGLKView.h
//  PictureFold
//
//  Created by 齐建琼 on 15/11/20.
//  Copyright © 2015年 齐建琼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES3/glext.h>
#import <OpenGLES/ES3/gl.h>

@class EAGLContext;
@protocol AGLKViewDelegate;

@interface AGLKView : UIView
{
    GLuint defaultFrameBuffer;
    GLuint colorRenderBuffer;
}
@property (nonatomic, weak) IBOutlet id <AGLKViewDelegate> delegate;
@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, readonly) NSInteger drawableWidth;
@property (nonatomic, readonly) NSInteger drawableHeight;

- (void)display;
@end
#pragma mark -
#pragma mark  AGLKViewDelegate
#pragma mark -
@protocol AGLKViewDelegate <NSObject>
@required
- (void)glkView:(AGLKView *)view drawInRect:(CGRect)rect;
@end