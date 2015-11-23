//
//  OpenGLViewController.h
//  PictureFold
//
//  Created by 齐建琼 on 15/11/20.
//  Copyright © 2015年 齐建琼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
@interface OpenGLViewController : GLKViewController
{
    GLuint vertextBufferID;
}
@property (strong, nonatomic) GLKBaseEffect *baseEffect;

@end
