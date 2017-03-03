//
//  WHSlideViewController.m
//  WHSlideViewController
//
//  Created by ios on 2017/3/3.
//  Copyright © 2017年 c. All rights reserved.
//

#import "WHSlideViewController.h"
#import "UIView+Extension.h"

@interface WHSlideViewController ()<UIGestureRecognizerDelegate>

//左侧视图控制器
@property (nonatomic, strong) UIViewController          *leftVC;

//中间视图控制器
@property (nonatomic, strong) UIViewController          *centerVC;

//侧滑窗打开状态
@property (nonatomic, assign) BOOL                      closedState;

//滑动手势
@property (nonatomic, strong) UIPanGestureRecognizer    *pan;

//点击手势
@property (nonatomic, strong) UITapGestureRecognizer    *tap;

//滑动的距离
@property (nonatomic, assign) float                      scale;

@end


@implementation WHSlideViewController

- (instancetype)initWithLeftVC:(UIViewController *) leftVC CenterVC:(UIViewController *) centerVC{
    if([super init]) {
        self.centerVC    =  centerVC;
        self.leftVC      =  leftVC;
        self.closedState =  YES;
        self.scale       =  0.f;
        [self.centerVC.view addGestureRecognizer:self.pan];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.leftVC.view];
    [self.view addSubview:self.centerVC.view];
}

- (void)handlerPan:(UIPanGestureRecognizer *) pan {
    CGPoint point  = [pan translationInView:self.view];//获取滑动手势的相对位移点
    
    if(pan.view.x >= 0&&pan.view.x <= DefalutMaxSlide) {
        CGFloat newCenterX = pan.view.center.x + point.x;
        if (newCenterX < ScreenWidth * 0.5) {
            newCenterX = ScreenWidth * 0.5;
        }
        
        pan.view.center = CGPointMake(newCenterX, pan.view.centerY);
    }
    [pan setTranslation:CGPointZero inView:self.view];
    
    //手势结束时,根据滑动的距离判断要进行的动作
    if(pan.state == UIGestureRecognizerStateEnded) {
        pan.view.x > DefalutMaxSlide/2.0?[self openLeftVC]:[self closeLeftVC];
    }

}

- (void)handlerTap:(UITapGestureRecognizer *) tap {
    [self closeLeftVC];
}

- (void)closeLeftVC {
    self.closedState = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.centerVC.view.frame = CGRectMake(0, 0, self.centerVC.view.width, self.centerVC.view.height);
    }];
    [self.centerVC.view removeGestureRecognizer:self.tap];
    self.tap = nil;
}

- (void)openLeftVC {
    self.closedState = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.centerVC.view.frame = CGRectMake(DefalutMaxSlide, 0, self.centerVC.view.width, self.centerVC.view.height);
    }];
    [self.centerVC.view addGestureRecognizer:self.tap];
}

#pragma mark lazyLoad
- (UIPanGestureRecognizer *)pan {
    if(!_pan) {
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlerPan:)];
        _pan.delegate = self;
        _pan.cancelsTouchesInView = YES;//手势响应优先于其他触摸事件(不能盖住button的点击)
    }
    return _pan;
}

- (UITapGestureRecognizer *)tap {
    if(!_tap) {
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlerTap:)];
        _tap.delegate = self;
        _tap.numberOfTapsRequired = 1;
        _tap.cancelsTouchesInView = YES;
    }
    return _tap;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
