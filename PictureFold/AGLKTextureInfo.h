//
//  AGLKTextureInfo.h
//  PictureFold
//
//  Created by 齐建琼 on 15/11/23.
//  Copyright © 2015年 齐建琼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface AGLKTextureInfo : NSObject
{
@private
    GLuint name;
    GLenum target;
    GLuint width;
    GLuint height;
}
@property (readonly) GLuint name;
@property (readonly) GLenum target;
@property (readonly) GLuint width;
@property (readonly) GLuint height;

@end

#pragma mark -
#pragma mark -AGLKTextureLoader
@interface AGLKTextureLoder : NSObject

+ (AGLKTextureInfo *)textureWithCGImage:(CGImageRef)cgImage options:(NSDictionary *)options error:(NSError **)outError;

@end