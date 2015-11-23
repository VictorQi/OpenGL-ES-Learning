//
//  TextureChangedViewController.h
//  PictureFold
//
//  Created by 齐建琼 on 15/11/23.
//  Copyright © 2015年 齐建琼. All rights reserved.
//

#import <GLKit/GLKit.h>
@class AGLKVertexAttribArrayBuffer;
@interface TextureChangedViewController : GLKViewController
@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexBuffer;
@property (nonatomic) BOOL shouldUseLinearFilter;
@property (nonatomic) BOOL shouldAnimating;
@property (nonatomic) BOOL shouldRepeatTexture;
@property (nonatomic) CGFloat sCoordinateOffse;
@end
