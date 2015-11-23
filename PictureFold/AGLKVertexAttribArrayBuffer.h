//
//  AGLKVertexAttribArrayBuffer.h
//  PictureFold
//
//  Created by 齐建琼 on 15/11/20.
//  Copyright © 2015年 齐建琼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;

typedef enum {
    AGLKVertexAttribPosition = GLKVertexAttribPosition,
    AGLKVertexAttribNormal = GLKVertexAttribNormal,
    AGLKVertexAttribColor = GLKVertexAttribColor,
    AGLKVertexAttribTexCoord0 = GLKVertexAttribTexCoord0,
    AGLKVertexAttribTexCoord1 = GLKVertexAttribTexCoord1,
}AGLKVertexAttrib;


@interface AGLKVertexAttribArrayBuffer : NSObject
{
    GLsizei    stride;
    GLsizeiptr bufferSizeBytes;
    GLuint     glName;
}

@property (nonatomic, readonly) GLuint     glName;
@property (nonatomic, readonly) GLsizeiptr bufferSizeBytes;
@property (nonatomic, readonly) GLsizei    stride;

- (id)initWithAttribStribe:(GLsizei)aStride
          numberOfVertices:(GLsizeiptr)count
                      data:(const GLvoid *)dataPtr
                     usage:(GLenum)usage;

- (void)prepareToDrawWithAttrib:(GLuint)index
            numberOfCoordinates:(GLint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable;

- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count;

- (void)reinitWithAttribStride:(GLsizei)aStride
              numberOfVertices:(GLsizei)count
                         bytes:(const GLvoid *)dataPtr;

+ (void)drawPreparedArraysWithMode:(GLenum)mode
                  startVertexIndex:(GLint)first
                  numberOfVertices:(GLsizei)count;

@end
