//
//  TextureViewController.h
//  PictureFold
//
//  Created by 齐建琼 on 15/11/23.
//  Copyright © 2015年 齐建琼. All rights reserved.
//

#import <GLKit/GLKit.h>
@class AGLKVertexAttribArrayBuffer;

@interface TextureViewController : GLKViewController
@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexBuffer;
@end
