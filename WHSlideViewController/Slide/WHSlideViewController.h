//
//  WHSlideViewController.h
//  WHSlideViewController
//
//  Created by ios on 2017/3/3.
//  Copyright © 2017年 c. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenWidth          [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight         [[UIScreen mainScreen] bounds].size.height

#define DefalutMaxSlide      ScreenWidth*0.8

@interface WHSlideViewController : UIViewController

//左侧视图控制器
@property (nonatomic, strong) UIViewController          *leftVC;

//中间视图控制器
@property (nonatomic, strong) UIViewController          *centerVC;

//是否在首页时允许滑动,默认是YES
@property (nonatomic, assign) BOOL                       isCanSlide;

+ (WHSlideViewController *)shareManager;

- (void)closeLeftVC;

- (void)openLeftVC;

- (void)presentNextVC:(UIViewController *) vc;

@end
