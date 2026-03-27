//
//  AccompanyNavView.m
//  Community
//
//  Created by 余莹 on 2020/12/8.
//

#import "AccompanyNavView.h"
#define BTN_TAG_Choose_Person 210
#define BTN_TAG_Choose_Car 211

@interface AccompanyNavView ()
@property (nonatomic,strong) UIView *backView;
@end
@implementation AccompanyNavView 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.choosePersonBtn];
        [self.backView addSubview:self.chooseCarBtn];
        [self setUI];
    }
    return self;
}
#pragma mark ==
- (void)chooseBtnAction:(UIButton *)sender{
    if (sender.selected==YES) {//原是已点击状态
        return;
    }
    //选择人
    if (sender.tag == BTN_TAG_Choose_Person) {
        if (self.choosePersonBtn.selected==YES) {
            return;//不变
        }else{
            self.choosePersonBtn.selected=YES;
            NSLog(@"choosePersonBtn");
            [self chooseDelegateWithType:Accompany_Type_Person];
            //切换
            self.chooseCarBtn.selected = NO;
        }
    }
    //选择车
    if (sender.tag == BTN_TAG_Choose_Car) {
        if (self.chooseCarBtn.selected==YES) {
            return;
        }else{
            self.chooseCarBtn.selected=YES;
            NSLog(@"chooseCarBtn");
            [self chooseDelegateWithType:Accompany_Type_Car];
            //切换
            self.choosePersonBtn.selected = NO;
        }
    }
}

- (void)chooseDelegateWithType:(Accompany_Type)type{
    if (_delegate && [_delegate respondsToSelector:@selector(accompanyNavViewSubBtnTouchChooseType:)]) {
        [_delegate accompanyNavViewSubBtnTouchChooseType:type];
    }
}
#pragma mark ==
- (void)setUI{
    _choosePersonBtn.selected = YES;
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview);
    }];
    [_choosePersonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_chooseCarBtn.superview.mas_centerY);
        make.left.equalTo(_chooseCarBtn.superview.mas_left);
        make.width.equalTo(_chooseCarBtn.superview.mas_width).multipliedBy(0.4);
        make.height.equalTo(_chooseCarBtn.superview.mas_height);
    }];
    [_chooseCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_choosePersonBtn.superview.mas_centerY);
        make.right.equalTo(_choosePersonBtn.superview.mas_right);
        make.width.equalTo(_choosePersonBtn.superview.mas_width).multipliedBy(0.4);
        make.height.equalTo(_choosePersonBtn.superview.mas_height);
    }];
}

#pragma mark ==
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
    }
    return _backView;
}
- (UIButton *)choosePersonBtn{
    if (!_choosePersonBtn) {
        _choosePersonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_choosePersonBtn setTitle:@"随行人员" forState:UIControlStateNormal];
        [_choosePersonBtn setTitleColor:[ThemeManager shareManager].guestAccompanyNavViewMainTextColor forState:UIControlStateSelected];
        [_choosePersonBtn setTitleColor:[ThemeManager shareManager].guestAccompanyNavViewMainDetailTextColor forState:UIControlStateNormal];
        _choosePersonBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _choosePersonBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _choosePersonBtn.tag = BTN_TAG_Choose_Person;
        [_choosePersonBtn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choosePersonBtn;
}
- (UIButton *)chooseCarBtn{
    if (!_chooseCarBtn) {
        _chooseCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseCarBtn setTitle:@"随行车辆" forState:UIControlStateNormal];
        [_chooseCarBtn setTitleColor:[ThemeManager shareManager].guestAccompanyNavViewMainTextColor forState:UIControlStateSelected];
        [_chooseCarBtn setTitleColor:[ThemeManager shareManager].guestAccompanyNavViewMainDetailTextColor forState:UIControlStateNormal];
        _chooseCarBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _chooseCarBtn.tag = BTN_TAG_Choose_Car;
        [_chooseCarBtn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseCarBtn;
}

@end
