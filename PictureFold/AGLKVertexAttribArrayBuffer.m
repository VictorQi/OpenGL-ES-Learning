//
//  AGLKVertexAttribArrayBuffer.m
//  PictureFold
//
//  Created by 齐建琼 on 15/11/20.
//  Copyright © 2015年 齐建琼. All rights reserved.
//

#import "AGLKVertexAttribArrayBuffer.h"

@interface AGLKVertexAttribArrayBuffer ()

@property (nonatomic, assign) GLsizeiptr bufferSizeBytes;
@property (nonatomic, assign) GLsizei stride;

@end

@implementation AGLKVertexAttribArrayBuffer

@synthesize glName;
@synthesize stride;
@synthesize bufferSizeBytes;

///创建缓冲区，绑定缓冲区并初始化数据
- (id)initWithAttribStribe:(GLsizei)aStride
          numberOfVertices:(GLsizeiptr)count
                      data:(const GLvoid *)dataPtr
                     usage:(GLenum)usage
{
    NSParameterAssert(0 < aStride);
    NSParameterAssert(0 < count);
    NSParameterAssert(NULL != dataPtr);
    
    self = [super init];
    if (self) {
        stride = aStride;
        bufferSizeBytes = stride * count;
        
        glGenBuffers(1, &glName);                                       //创建缓冲区--1
        glBindBuffer(GL_ARRAY_BUFFER, self.glName);                     //绑定缓冲区--2
        glBufferData(GL_ARRAY_BUFFER, bufferSizeBytes, dataPtr, usage); //初始化数据--3
        
        NSAssert(glName != 0, @"Failed to generate glName");
    }
    
    return self;
}

///重新绑定顶点缓冲区，初始化数据
- (void)reinitWithAttribStride:(GLsizei)aStride
              numberOfVertices:(GLsizei)count
                         bytes:(const GLvoid *)dataPtr
{
    NSParameterAssert(aStride > 0);
    NSParameterAssert(count > 0);
    NSParameterAssert(dataPtr != NULL);
    
    glBindBuffer(GL_ARRAY_BUFFER, self.glName);                          //绑定缓冲区--2
    glBufferData(GL_ARRAY_BUFFER, bufferSizeBytes, dataPtr, GL_DYNAMIC_DRAW); //初始化数据--3
}

///开启顶点数组，并为顶点着色器位置信息赋值
- (void)prepareToDrawWithAttrib:(GLuint)index
            numberOfCoordinates:(GLint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable
{
    NSParameterAssert(count>0 && count<4);
    NSParameterAssert(offset < self.stride);
    NSAssert(glName != 0, @"Invalid glName");
    
    glBindBuffer(GL_ARRAY_BUFFER, self.glName);
    if (shouldEnable) {
        glEnableVertexAttribArray(index);                                  //开启顶点数组--4
    }
    
    glVertexAttribPointer(index,                                           //为顶点着色器位置信息赋值--5
                          count,
                          GL_FLOAT,
                          GL_FALSE,
                          self.stride,
                          NULL+offset);
    
}

///使用某一模式渲染顶点数组
- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count
{
    NSAssert(self.bufferSizeBytes >= ((first + count)*self.stride),
             @"Attempt to draw vertex data than available");
    glDrawArrays(mode, first, count);                                      //将顶点数组使用某一模式渲染--6
}

///类方法，使用某一模式渲染顶点数组
+ (void)drawPreparedArraysWithMode:(GLenum)mode
                  startVertexIndex:(GLint)first
                  numberOfVertices:(GLsizei)count
{
    glDrawArrays(mode, first, count);                                       //将顶点数组使用某一模式渲染--6
}

///渲染结束，关闭数组
- (void)dealloc{
    if (glName != 0) {
        glDeleteBuffers(1, &glName);                                        //渲染结束，关闭数组--7
        glName = 0;
    }
}
@end
