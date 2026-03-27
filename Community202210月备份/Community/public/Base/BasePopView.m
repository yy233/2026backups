//
//  BasePopView.m
//  Community
//
//  Created by 余莹 on 2020/12/4.
//

#import "BasePopView.h"

@interface BasePopView ()
//@property (nonatomic,assign) float subMainViewHeight;//内容高度
@property (nonatomic,strong) UIView *backView;//全背景 Screen_h
//@property (nonatomic,strong) UIView *subMainBackView;//显示内容的背景
@property (nonatomic,strong) UIButton *bottomBtn;
@property (nonatomic,assign) float animationTime;
@end
@implementation BasePopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, Screen_W, Screen_H); ;//frame 00范围，点击事件不可响应，会点到父视图
        [self initAttibute];
        [self initView];
        [self changMainBackViewCornerRadius];
        [self changMainBackViewBackColor];
     }
    return self;
}
- (void)initAttibute{
    [self initAttribute];
}
- (void)initView{
    [self addSubview:self.backView];
    [self.backView addSubview:self.subMainBackView];
    [self.backView addSubview:self.bottomBtn];
  
}
#pragma mark ===========
/**
 *  展示pop视图 和 数据
 */
- (void)showInView:(UIView *)supview thePopViewSubViewHeight:(float)subViewHeight WithArray:(NSMutableArray *)array{
    //
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIWindow *window = [Tool toolGetKeyWindow];
    supview = window.rootViewController.view;
    //
    if (!supview) {
        return;
    }
    self.subMainViewHeight = subViewHeight;
    dispatch_async(dispatch_get_main_queue(), ^{
        [supview addSubview:self];
        //
        [self.backView setFrame:CGRectMake(0, Screen_H, Screen_W, 0)];
        [UIView animateWithDuration:self.animationTime animations:^{
            self.alpha = 1.0;
            self.backView.frame = CGRectMake(0, 0, Screen_W, Screen_H);
        } completion:nil];
        self.dataSourceArr = array;
    });
}
- (void)showInSuperviewWithSendSuperV:(UIView *)supview thePopViewSubViewHeight:(float)subViewHeight WithArray:(NSMutableArray *)array{
  
    if (!supview) {
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIWindow *window = [Tool toolGetKeyWindow];
        supview = window.rootViewController.view;
        //
    }
    self.subMainViewHeight = subViewHeight;
    dispatch_async(dispatch_get_main_queue(), ^{
        [supview addSubview:self];
        //
        [self.backView setFrame:CGRectMake(0, Screen_H, Screen_W, 0)];
        [UIView animateWithDuration:self.animationTime animations:^{
            self.alpha = 1.0;
            self.backView.frame = CGRectMake(0, 0, Screen_W, Screen_H);
        } completion:nil];
        self.dataSourceArr = array;
    });
}
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
    
}

/**
 *  消失pop视图
 */
- (void)dismissThePopView{//  CGPoint center = self.backcontentView.center;
    [self.backView setFrame:self.backView.frame];;
    [UIView animateWithDuration:self.animationTime
                     animations:^{
        self.alpha = 0.0;
        [self.backView setFrame:CGRectMake(0, Screen_H, Screen_W, 0)];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        [self.backView removeFromSuperview];
    }];
    [self dismissPopViewHaveOtherAction];//消失时 的方法
    [self dismissOKWithDelegateAction];//消失时通知协议方 有的用来做nil
}
- (void)dismissPopViewHaveOtherAction{ //待复用
    
}
#pragma mark == getter
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    DLog(@"touchesBegan");
    [self dismissThePopView];
}

#pragma mark == delegate
- (void)dismissOKWithDelegateAction{
    if (_basePopViewDelegate && [_basePopViewDelegate respondsToSelector:@selector(basePopViewDelegateWithDissmissEndInfo)]) {
        [_basePopViewDelegate basePopViewDelegateWithDissmissEndInfo];
    }
}


#pragma  mark===

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.frame = CGRectMake(0, 0, Screen_W, Screen_H);
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    }
    return _backView;
}

- (UIView *)subMainBackView{
    if (!_subMainBackView) {
        _subMainBackView = [[UIView alloc]init];
//        _subMainBackView.frame = CGRectMake(0, Screen_H-KNavBarHeight-self.subMainViewHeight+10, Screen_W,self.subMainViewHeight);
        _subMainBackView.frame = CGRectMake(0, Screen_H-self.subMainViewHeight+10, Screen_W,self.subMainViewHeight);//换成window rootvc view 后 knavH去掉
        _subMainBackView.layer.cornerRadius = 10;
        _subMainBackView.layer.masksToBounds = YES;
        _subMainBackView.backgroundColor = [UIColor whiteColor];
    }
    return _subMainBackView;
}


#pragma mark == 初始化动画时间  初始化 内容高度
- (void)initAttribute{
    [self initAnimationTime];
    [self initSubMainHeight];
}
- (void)initAnimationTime{
    self.animationTime = 0.3;
}
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H*0.5;
}
- (void)changMainBackViewBackColor{
//    _subMainBackView.backgroundColor = ;
}

//用于子类重写
- (void)changMainBackViewCornerRadius{
//    _subMainBackView.layer.cornerRadius = cornerRadusNum;
}


//- (float)subMainViewHeight{
//    if (!_subMainViewHeight) {
//        _subMainViewHeight = Screen_H*0.5;//子内容部分显示高度
//    }
//    return _subMainViewHeight;
//}
@end
