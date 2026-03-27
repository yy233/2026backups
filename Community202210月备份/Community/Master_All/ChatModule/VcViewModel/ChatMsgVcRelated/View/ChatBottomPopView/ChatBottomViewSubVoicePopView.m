//
//  ChatBottomViewSubVoicePopView.m
//  Community
//
//  Created by 余莹 on 2021/5/14.
//

#import "ChatBottomViewSubVoicePopView.h"

@interface ChatBottomViewSubVoicePopView ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UILabel   *titleL;
@property (nonatomic,strong) YBtnWithGesture  *centerVoiceBtn;
@property (nonatomic,strong) UIImageView *centerImgV;
@property (nonatomic,strong) UIButton  *dismissVoicePopviewBtn;
@end

@implementation ChatBottomViewSubVoicePopView
#pragma mark == 重写
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubAllView];
        [self setUI];
    }
    return self;
}
#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H*0.4;
}
#pragma mark == 边角 重写
- (void)changMainBackViewCornerRadius{
    self.subMainBackView.layer.cornerRadius = 15;
}

#pragma mark ====
- (void)addSubAllView{
    [self.subMainBackView addSubview:self.titleL];
    [self.subMainBackView addSubview:self.centerVoiceBtn];
//    [self.subMainBackView addSubview:self.centerImgV];//暂不用
    [self.subMainBackView addSubview:self.dismissVoicePopviewBtn];
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.subMainBackView);
        make.width.equalTo(self.subMainBackView).multipliedBy(0.6);
        make.height.offset(36);
        make.top.offset(20);
    }];
    [_centerVoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.subMainBackView);
        make.width.equalTo(self.subMainBackView).multipliedBy(0.35);
        make.height.equalTo(_centerVoiceBtn.mas_width);
//        make.top.equalTo(_titleL.mas_bottom).offset(30);
        make.centerY.equalTo(self.subMainBackView);

    }];
    
//    [_centerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_centerVoiceBtn);
//    }];
    [_dismissVoicePopviewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.subMainBackView);
        make.bottom.equalTo(self.subMainBackView);
        make.width.equalTo(self.subMainBackView).multipliedBy(0.3);
        make.height.offset(40);
    }];

}
 
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"按住说话";
        _titleL.font = [UIFont systemFontOfSize:15];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.numberOfLines = 3;
        _titleL.textColor = Y_ColorWith16FromRGB(0x888888);
    }
    return _titleL;
}
- (YBtnWithGesture *)centerVoiceBtn{
    if (!_centerVoiceBtn) {
        _centerVoiceBtn = [YBtnWithGesture buttonWithType:UIButtonTypeCustom];
        [_centerVoiceBtn newAnBtnWithImg:[UIImage imageNamed:@"fun_voice_ico_"]];
        [_centerVoiceBtn setFrame:CGRectMake(0, 0, 80, 80)];
        _centerVoiceBtn.userInteractionEnabled = YES;
        WEAKSELF
        _centerVoiceBtn.longPressBlock = ^(UILongPressGestureRecognizer * sender) {
            [weakSelf longPressUp:sender];
        };
     }
    return _centerVoiceBtn;
}
- (UIImageView *)centerImgV{//暂未使用
    if (!_centerImgV) {
        _centerImgV = [[UIImageView alloc]init];
        _centerImgV.userInteractionEnabled = YES;
        _centerImgV.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.2];
    }
    return _centerImgV;
}
- (UIButton *)dismissVoicePopviewBtn{
    if (!_dismissVoicePopviewBtn) {
        _dismissVoicePopviewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _dismissVoicePopviewBtn;
}
#pragma mark ==== 长按手势
//音量+长按事件逻辑
- (void)longPressUp:(UILongPressGestureRecognizer *)longGes{
  
    switch (longGes.state) {
        case UIGestureRecognizerStateBegan:
             //begin
        {
            NSLog(@"音____begin ");
            dispatch_async(dispatch_get_main_queue(), ^{
                self.titleL.text = @"松开发送";
            });
            if (_delegate && [_delegate respondsToSelector:@selector(subPopViewVoiceBtnLongPressActionType:)]) {
                 [_delegate subPopViewVoiceBtnLongPressActionType:LongPressActionType_Begin];
             }
        }
            break;
        case UIGestureRecognizerStateEnded:
             //end
        {
            NSLog(@"音____end ");
            CGPoint location = [longGes locationInView:self.centerVoiceBtn];
                
            if (CGRectContainsPoint(self.centerVoiceBtn.bounds,location)){
                NSLog(@"音____ Ended 在中心");
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.titleL.text = @"松开发送";
                });
                if (_delegate && [_delegate respondsToSelector:@selector(subPopViewVoiceBtnLongPressActionType:)]) {
                     [_delegate subPopViewVoiceBtnLongPressActionType:LongPressActionType_End];
                 }
            }else{
                NSLog(@"音____ Ended 越界");
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.titleL.text = @"手势在录音按钮外，松开即可取消本条语音发送";
                });
                Y_SVP_SHOW_INFO_MES(@"已经取消本条语音发送。");
                if (_delegate && [_delegate respondsToSelector:@selector(subPopViewVoiceBtnLongPressActionType:)]) {
                     [_delegate subPopViewVoiceBtnLongPressActionType:LongPressActionType_Cancel];
                 }
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint location = [longGes locationInView:self.centerVoiceBtn];
            if (CGRectContainsPoint(self.centerVoiceBtn.bounds,location)){
                NSLog(@"音____change 在中心");
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.titleL.text = @"松开发送";
                });
            }else{
                NSLog(@"音____change 越界");
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.titleL.text = @"手势在录音按钮外，松开即可取消本条语音发送";
                });
            
            }
        }
            break;
        
        default:
            NSLog(@"音____%ld",longGes.state);//中途
            
            if (_delegate && [_delegate respondsToSelector:@selector(subPopViewVoiceBtnLongPressActionType:)]) {
                 [_delegate subPopViewVoiceBtnLongPressActionType:LongPressActionType_Other];
             }
            break;
    }


}
 
@end
