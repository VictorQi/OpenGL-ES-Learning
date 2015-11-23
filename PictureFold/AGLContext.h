//
//  AGLContext.h
//  PictureFold
//
//  Created by 齐建琼 on 15/11/20.
//  Copyright © 2015年 齐建琼. All rights reserved.
//


#import <GLKit/GLKit.h>

@interface AGLContext : EAGLContext

@property (nonatomic, assign, readwrite) GLKVector4 aClearColor;

- (void)clear:(GLbitfield)mask;
- (void)setBlendSourceFactor:(GLenum)sFactor
           destinationFactor:(GLenum)dFactor;
@end
