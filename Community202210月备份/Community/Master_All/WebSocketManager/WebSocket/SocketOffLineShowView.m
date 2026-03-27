//
//  SocketOffLineShowView.m
//  Community
//
//  Created by 余莹 on 2022/3/21.
//

#import "SocketOffLineShowView.h"
#import "ExitActionWithCleanOrChangeUserInfoTool.h"//退出登录 的数据清理

static NSString *kTextViewDefault = @"用户您好：\n 您的账号在其他客户端登录，当前客户端已经离线，即将退出登录。";


@interface SocketOffLineShowView ()
@property (nonatomic,strong) UIView *backCenterGroundView;
@property (nonatomic,strong) UIButton *bottomBtn;
@property (nonatomic,strong) UITextView *textView;

@end


@implementation SocketOffLineShowView
 
- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, Screen_H);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [Y_ColorWith16FromRGB(0x2b2c2f) colorWithAlphaComponent:0.7];
        [self addSubview:self.backCenterGroundView];
        [self.backCenterGroundView addSubview:self.textView];
        [self.backCenterGroundView addSubview:self.bottomBtn];
        [self setUI];
        self.textView.text = kTextViewDefault;
        [self textViewInitShowStr];
    }
    return self;
}
- (void)setUI{
    [_backCenterGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_backCenterGroundView.superview);
        make.width.equalTo(_backCenterGroundView.superview).multipliedBy(0.7);
        make.height.equalTo(_backCenterGroundView.mas_width).multipliedBy(1.0);
    }];
    [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100.0);
        make.height.offset(40);
        make.centerX.equalTo(_bottomBtn.superview);
        make.bottom.equalTo(_bottomBtn.superview).offset(-20);
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_textView.superview);
        make.width.equalTo(_textView.superview).offset(-60);
        make.top.equalTo(_textView.superview).offset(20);
        make.bottom.equalTo(_bottomBtn.mas_top).offset(-20);
    }];
    
}

- (void)textViewInitShowStr{
  
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: Y_ColorWith16FromRGB(0x59231B)
                                 };
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:kTextViewDefault attributes:attributes];
}

#pragma mark ==

- (UIView *)backCenterGroundView{
    if (!_backCenterGroundView) {
        _backCenterGroundView = [[UIView alloc]init];
        _backCenterGroundView.backgroundColor = Y_ColorWith16FromRGB(0xffffff);
        _backCenterGroundView.layer.cornerRadius = 10.f;
        _backCenterGroundView.clipsToBounds = YES;
    }
    return _backCenterGroundView;
}
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.textColor = Y_ColorWith16FromRGB(0x59231B);
        _textView.font = [UIFont systemFontOfSize:14.0];
        _textView.editable = NO;
        //_textView.backgroundColor = [UIColor clearColor];
    }
    return _textView;
}


- (UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn newAnBtnWithTextStr:@"知道了"];
        [_bottomBtn newAnBtnWithTextColor: Y_ColorWith16FromRGB(0xffffff)];
        [_bottomBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:15.0]];
        [_bottomBtn newAnBtnWithBackColor: Color_Blue];
        [_bottomBtn newAnBtnWithLayerCorNerNum:18.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_bottomBtn addTarget:self action:@selector(bottomBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}
- (void)bottomBtnAction{//删除本视图
    dispatch_async(dispatch_get_main_queue(), ^{
       //动画
        [UIView animateWithDuration:0.3 animations:^{
            self.backCenterGroundView.alpha = 0.1;
            self.bottomBtn.alpha = 0.1;
            self.textView.alpha = 0.1;
        } completion:^(BOOL finished) {
        }];
        [self exitAction];//先做rootVc处理
        [self performSelector:@selector(removeAction) withObject:nil afterDelay:0.3];//再removeSelf

    });
}
- (void)removeAction{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)exitAction{
    [ExitActionWithCleanOrChangeUserInfoTool exitActionWithDealUseInfo];// //退出登录 的数据清理    
  
    [(AppDelegate *)[UIApplication sharedApplication].delegate showWindowHome:kWindowType_Logout];  //rootvc页面切换
    /**
     //可用但是13.0下
    LoginVC *loginVC = [[LoginVC alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];//可用
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
     **/
  
}

//获取 view所在的VC 暂时没有使用
- (UIViewController*)nowthisViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
 
@end
