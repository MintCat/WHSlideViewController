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

#define DefalutAlpha         0.5

@interface WHSlideViewController : UIViewController

//初始化
- (instancetype)initWithLeftVC:(UIViewController *) leftVC CenterVC:(UIViewController *) centerVC;

- (void)closeLeftVC;

- (void)openLeftVC;

@end
