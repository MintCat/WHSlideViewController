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

//侧滑窗打开状态
@property (nonatomic, assign) BOOL                      closedState;

//滑动手势
@property (nonatomic, strong) UIPanGestureRecognizer    *pan;

//点击手势
@property (nonatomic, strong) UITapGestureRecognizer    *tap;

//菜单视图控制器里的列表
@property (nonatomic, weak)   UITableView               *tableView;

@end


@implementation WHSlideViewController
#pragma mark 创建单例
+ (WHSlideViewController *)shareManager {
    static WHSlideViewController *managerInstance = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        managerInstance = [[WHSlideViewController alloc]init];
    });
    return managerInstance;
}

#pragma mark 变量的setter方法
- (void)setLeftVC:(UIViewController *)leftVC {
    if(_leftVC == leftVC||!leftVC) return;
    
    //添加新的之前先移除旧的
    [_leftVC.view removeFromSuperview];
    _leftVC = nil;
        
    _leftVC = leftVC;
    //获取菜单视图控制器的列表,并改变其中心和大小,为水平缩放做准备
    for(UIView *view in _leftVC.view.subviews) {
        if([view isKindOfClass:[UITableView class]]) {
            self.tableView = (UITableView *)view;
            self.tableView.bounds = CGRectMake(0, 0, DefalutMaxSlide, ScreenHeight);
            self.tableView.center = CGPointMake(0, ScreenHeight/2.0);
            break;
        }
    }
    [self.view addSubview:_leftVC.view];
}

- (void)setCenterVC:(UIViewController *)centerVC {
    if(_centerVC == centerVC||!centerVC) return;
    
    [_centerVC.view removeGestureRecognizer:self.pan];
    self.pan = nil;
    [_centerVC.view removeGestureRecognizer:self.tap];
    self.tap = nil;
    [_centerVC.view removeFromSuperview];
    _centerVC = nil;
    
    _centerVC = centerVC;
    //为中间视图添加阴影效果,看起来更像抽屉
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_centerVC.view.bounds];
    _centerVC.view.layer.masksToBounds = NO;
    _centerVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
    _centerVC.view.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    _centerVC.view.layer.shadowOpacity = 0.5f;
    _centerVC.view.layer.shadowPath = shadowPath.CGPath;
    
    [self.view addSubview:self.centerVC.view];
    [_centerVC.view addGestureRecognizer:self.pan];
    
}

- (void)setIsCanSlide:(BOOL)isCanSlide {
    _isCanSlide = isCanSlide;
    
    if(self.closedState&&!_isCanSlide) {
        self.pan.enabled = NO;
    }
}

- (void)setClosedState:(BOOL)closedState {
    _closedState = closedState;
    if(!_closedState) {
        self.pan.enabled = YES;
    }else {
        if(!self.isCanSlide) {
            self.pan.enabled = NO;
        }
    }
    
}

#pragma mark 视图控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.closedState =  YES;
    self.isCanSlide  =  YES;
}

#pragma mark 滑动和点击手势处理
- (void)handlerPan:(UIPanGestureRecognizer *) pan {
    //滑动前,判断导航控制器的视图控制器个数是否大于1,是则不能滑动
    UINavigationController *tempNav = (UINavigationController *)self.centerVC;
    if([tempNav isKindOfClass:[UINavigationController class]]&&tempNav.viewControllers.count > 1) {
        return;
    }
    
    //获取滑动手势的相对位移点
    CGPoint point  = [pan translationInView:self.view];
    
    if(pan.view.x >= 0&&pan.view.x <= DefalutMaxSlide) {
        CGFloat newCenterX = pan.view.center.x + point.x;
        if (newCenterX < ScreenWidth * 0.5) {
            newCenterX = ScreenWidth * 0.5;
        }
        
        //改变中间视图控制器的中心
        pan.view.center = CGPointMake(newCenterX, pan.view.centerY);
        
        //改变菜单列表的中心和水平缩放
        self.tableView.center = CGPointMake(pan.view.x/2.0, ScreenHeight/2.0);
        self.tableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, pan.view.x/(DefalutMaxSlide), 1);
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

#pragma mark 打开和关闭菜单方法
- (void)closeLeftVC {
    self.closedState = YES;
    [UIView animateWithDuration:0.25 animations:^{
        //中间视图控制器中心点
        self.centerVC.view.center = CGPointMake(ScreenWidth/2.0, ScreenHeight/2.0);
        
        //菜单列表中心点和水平缩放(X方向的值不能直接为0,否则视图会消失)
        self.tableView.center = CGPointMake(0, ScreenHeight/2.0);
        self.tableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1f, 1.0);
    }];
    [self.centerVC.view removeGestureRecognizer:self.tap];
    self.tap = nil;
    
    for(UIButton *button in self.centerVC.view.subviews) {
        button.enabled = YES;
    }
}

- (void)openLeftVC {
    self.closedState = NO;
    [UIView animateWithDuration:0.25 animations:^{
        //中间视图控制器中心点
        self.centerVC.view.frame = CGRectMake(DefalutMaxSlide, 0, self.centerVC.view.width, self.centerVC.view.height);
        
        //菜单列表中心点和水平缩放
        self.tableView.center = CGPointMake(DefalutMaxSlide/2.0, ScreenHeight/2.0);
        self.tableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    }];
    [self.centerVC.view addGestureRecognizer:self.tap];
    
    //因为手势盖不住button的响应事件,所以做特殊处理
    for(UIButton *button in self.centerVC.view.subviews) {
        button.enabled = NO;
    }
}

#pragma mark 懒加载
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
