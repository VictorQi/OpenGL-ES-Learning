//
//  AGLKTextureInfo.m
//  PictureFold
//
//  Created by 齐建琼 on 15/11/23.
//  Copyright © 2015年 齐建琼. All rights reserved.
//

#import "AGLKTextureInfo.h"

typedef enum{
    AGLK1   = 1<<0,
    AGLK2   = 1<<1,
    AGLK4   = 1<<2,
    AGLK8   = 1<<3,
    AGLK16  = 1<<4,
    AGLK32  = 1<<5,
    AGLK64  = 1<<6,
    AGLK128 = 1<<7,
    AGLK256 = 1<<8,
    AGLK512 = 1<<9,
    AGLK1024= 1<<10,
}AGLKPowerOf2;

static NSData *AGLKDataWithResizedCGImageBytes(CGImageRef cgImage,
                                               size_t *widthPtr,
                                               size_t *heightPtr);


#pragma mark - 
#pragma mark AGLKTextureInfo的AGLKTextureLoder类别
@interface AGLKTextureInfo (AGLKTextureLoder)
- (id)initWithName:(GLuint)aName
            target:(GLenum)aTarget
             width:(GLuint)aWidth
            height:(GLuint)aHeight;
@end

@implementation AGLKTextureInfo (AGLKTextureLoder)

- (id)initWithName:(GLuint)aName
            target:(GLenum)aTarget
             width:(GLuint)aWidth
            height:(GLuint)aHeight
{
    self = [super init];
    if (self) {
        name = aName;
        target = aTarget;
        width = aWidth;
        height = aHeight;
    }
    return self;
}

@end

#pragma mark -
#pragma mark AGLKTextureInfo类的真正实现
@implementation AGLKTextureInfo
@synthesize name;
@synthesize target;
@synthesize height;
@synthesize width;
@end

#pragma mark -
#pragma mark AGLKTextureLoder类的真正实现

@implementation AGLKTextureLoder

+ (AGLKTextureInfo *)textureWithCGImage:(CGImageRef)cgImage
                                options:(NSDictionary *)options
                                  error:(NSError *__autoreleasing *)outError
{
    size_t height;
    size_t width;
    
    NSData *imageData = AGLKDataWithResizedCGImageBytes(cgImage, &width, &height);
    
    GLuint textureBufferID;
    
    glGenTextures(1, &textureBufferID);
    glBindTexture(GL_TEXTURE_2D, textureBufferID);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, [imageData bytes]);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    AGLKTextureInfo *result = [[AGLKTextureInfo alloc]initWithName:textureBufferID target:GL_TEXTURE_2D width:width height:height];

    return result;
}

static AGLKPowerOf2 AGLKCalculatePowerOf2ForDimension(
                                                      GLuint dimension)
{
    AGLKPowerOf2  result = AGLK1;
    
    if(dimension > (GLuint)AGLK512)
    {
        result = AGLK1024;
    }
    else if(dimension > (GLuint)AGLK256)
    {
        result = AGLK512;
    }
    else if(dimension > (GLuint)AGLK128)
    {
        result = AGLK256;
    }
    else if(dimension > (GLuint)AGLK64)
    {
        result = AGLK128;
    }
    else if(dimension > (GLuint)AGLK32)
    {
        result = AGLK64;
    }
    else if(dimension > (GLuint)AGLK16)
    {
        result = AGLK32;
    }
    else if(dimension > (GLuint)AGLK8)
    {
        result = AGLK16;
    }
    else if(dimension > (GLuint)AGLK4)
    {
        result = AGLK8;
    }
    else if(dimension > (GLuint)AGLK2)
    {
        result = AGLK4;
    }
    else if(dimension > (GLuint)AGLK1)
    {
        result = AGLK2;
    }
    
    return result;
}

static NSData *AGLKDataWithResizedCGImageBytes(
                                               CGImageRef cgImage,
                                               size_t *widthPtr,
                                               size_t *heightPtr)
{
    NSCParameterAssert(NULL != cgImage);
    NSCParameterAssert(NULL != widthPtr);
    NSCParameterAssert(NULL != heightPtr);
    
    GLuint originalWidth = (GLuint)CGImageGetWidth(cgImage);
    GLuint originalHeight = (GLuint)CGImageGetWidth(cgImage);
    
    NSCAssert(0 < originalWidth, @"Invalid image width");
    NSCAssert(0 < originalHeight, @"Invalid image width");
    
    // Calculate the width and height of the new texture buffer
    // The new texture buffer will have power of 2 dimensions.
    GLuint width = AGLKCalculatePowerOf2ForDimension(
                                                     originalWidth);
    GLuint height = AGLKCalculatePowerOf2ForDimension(
                                                      originalHeight);
    
    // Allocate sufficient storage for RGBA pixel color data with
    // the power of 2 sizes specified
    NSMutableData    *imageData = [NSMutableData dataWithLength:
                                   height * width * 4];  // 4 bytes per RGBA pixel
    
    NSCAssert(nil != imageData,
              @"Unable to allocate image storage");
    
    // Create a Core Graphics context that draws into the
    // allocated bytes
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate(
                                                   [imageData mutableBytes], width, height, 8,
                                                   4 * width, colorSpace,
                                                   kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    // Flip the Core Graphics Y-axis for future drawing
    CGContextTranslateCTM (cgContext, 0, height);
    CGContextScaleCTM (cgContext, 1.0, -1.0);
    
    // Draw the loaded image into the Core Graphics context 
    // resizing as necessary
    CGContextDrawImage(cgContext, CGRectMake(0, 0, width, height),
                       cgImage);
    
    CGContextRelease(cgContext);
    
    *widthPtr = width;
    *heightPtr = height;
    
    return imageData;
}

@end