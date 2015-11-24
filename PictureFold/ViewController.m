//
//  ViewController.m
//  PictureFold
//
//  Created by 齐建琼 on 15/11/19.
//  Copyright © 2015年 齐建琼. All rights reserved.
//

#import "ViewController.h"
#import "OpenGLViewController.h"
#import "TextureViewController.h"
#import "TextureChangedViewController.h"
#import "MixTextureViewController.h"

#define IMAGE_PER_HEIGHT 50

@interface ViewController ()
@property (strong, nonatomic) UIImageView *one;
@property (strong, nonatomic) UIImageView *two;
@property (strong, nonatomic) UIImageView *three;
@property (strong, nonatomic) UIImageView *four;
@property (strong, nonatomic) UIView *oneShadowView;
@property (strong, nonatomic) UIView *threeShadowView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configFourFoldImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)configFourFoldImage{
    UIView *bigImageView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 300)/2, 120, 300, IMAGE_PER_HEIGHT * 4)];
    [self.view addSubview:bigImageView];
    
    UIImage *mainImage = [UIImage imageNamed:@"aodamiao.png"];

    _one = [[UIImageView alloc] init];
    _one.image = mainImage;
    _one.layer.contentsRect = CGRectMake(0, 0, 1, 0.25);
    _one.layer.anchorPoint = CGPointMake(0.5, 0.0);
    _one.frame = CGRectMake(0, 0, 300, IMAGE_PER_HEIGHT);
    
    _two = [[UIImageView alloc]init];
    _two.image = mainImage;
    _two.layer.contentsRect = CGRectMake(0, 0.25, 1, 0.25);
    _two.layer.anchorPoint = CGPointMake(0.5, 1.0);
    _two.frame = CGRectMake(0, IMAGE_PER_HEIGHT, 300, IMAGE_PER_HEIGHT);
    
    _three = [[UIImageView alloc]init];
    _three.image = mainImage;
    _three.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.25);
    _three.layer.anchorPoint = CGPointMake(0.5, 0.0);
    _three.frame = CGRectMake(0, IMAGE_PER_HEIGHT * 2, 300, IMAGE_PER_HEIGHT);
    
    _four = [[UIImageView alloc]init];
    _four.image = mainImage;
    _four.layer.contentsRect = CGRectMake(0, 0.75, 1, 0.25);
    _four.layer.anchorPoint = CGPointMake(0.5, 1.0);
    _four.frame = CGRectMake(0, IMAGE_PER_HEIGHT * 3, 300, IMAGE_PER_HEIGHT);
    
    [bigImageView addSubview:_one];
    [bigImageView addSubview:_two];
    [bigImageView addSubview:_three];
    [bigImageView addSubview:_four];
    
    _oneShadowView = [[UIView alloc]initWithFrame:_one.bounds];
    _oneShadowView.backgroundColor = [UIColor blackColor];
    _oneShadowView.alpha = 0.0;
    
    _threeShadowView = [[UIView alloc]initWithFrame:_three.bounds];
    _threeShadowView.backgroundColor = [UIColor blackColor];
    _threeShadowView.alpha = 0.0;
    
    [_one addSubview:_oneShadowView];
    [_three addSubview:_threeShadowView];
}


- (CATransform3D)configRotateByAngle:(double)angle anPositionY:(double)y{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/2000;
    
    CATransform3D rotateTransform = CATransform3DRotate(transform, M_PI * angle / 180, 1, 0, 0);
    CATransform3D moveTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(0, y));
    
    CATransform3D contactTransform = CATransform3DConcat(rotateTransform, moveTransform);
    
    return contactTransform;
}

static bool isFolding = NO;

- (IBAction)foldAction:(id)sender {
    if(!isFolding)
    {
        isFolding = YES;
        
        [UIView animateWithDuration:1.0
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             // 阴影显示
                             _oneShadowView.alpha = 0.2;
                             _threeShadowView.alpha = 0.2;
                             
                             // 折叠
                             _one.layer.transform = [self configRotateByAngle:45.0 anPositionY:0];
                             _two.layer.transform = [self configRotateByAngle:45.0 anPositionY:-100+2*_one.frame.size.height];
                             _three.layer.transform = [self configRotateByAngle:-45.0 anPositionY:-100+2*_one.frame.size.height];
                             _four.layer.transform = [self configRotateByAngle:45.0 anPositionY:-200+4*_one.frame.size.height];
                             
                         } completion:^(BOOL finished) {
                             
                             if(finished)
                             {
                                 isFolding = NO;
                             }
                         }];
    }
}

- (IBAction)capture:(id)sender {
    OpenGLViewController *destination = [[OpenGLViewController alloc]init];
   [self.navigationController pushViewController:destination animated:YES];
    
}

- (IBAction)resetAction:(id)sender {
    isFolding = NO;
    
    [UIView animateWithDuration:1.0
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         // 阴影隐藏
                         _oneShadowView.alpha = 0.0;
                         _threeShadowView.alpha = 0.0;
                         
                         // 图片恢复原样
                         _one.layer.transform = CATransform3DIdentity;
                         _two.layer.transform = CATransform3DIdentity;
                         _three.layer.transform = CATransform3DIdentity;
                         _four.layer.transform = CATransform3DIdentity;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (IBAction)takeMixTexture:(UIButton *)sender {
    MixTextureViewController *destination = [[MixTextureViewController alloc]init];
    [self.navigationController pushViewController:destination animated:YES];
}

- (IBAction)textureMoved:(UIButton *)sender {
    TextureChangedViewController *destination = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"gridTexture"];
    [self.navigationController pushViewController:destination animated:YES];
}

- (IBAction)texture:(id)sender {
    TextureViewController *destination = [[TextureViewController alloc]init];

    [self.navigationController pushViewController:destination animated:YES];
}

@end
