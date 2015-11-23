//
//  AGLContext.m
//  PictureFold
//
//  Created by 齐建琼 on 15/11/20.
//  Copyright © 2015年 齐建琼. All rights reserved.
//

#import "AGLContext.h"

@implementation AGLContext

- (void)setClearColor:(GLKVector4)clearColorRGBA{
    _aClearColor = clearColorRGBA;
    NSAssert(self == [[self class]currentContext], @"Receiving context required to be current context");
    
    glClearColor(clearColorRGBA.r, clearColorRGBA.g, clearColorRGBA.b, clearColorRGBA.a);
}

- (GLKVector4)aClearColor{
    return _aClearColor;
}

- (void)clear:(GLbitfield)mask{
    NSAssert(self == [[self class]currentContext], @"Receiving context required to be current context");
    glClear(mask);
}

- (void)setBlendSourceFactor:(GLenum)sFactor
           destinationFactor:(GLenum)dFactor
{
    glBlendFunc(sFactor, dFactor);
}
@end
