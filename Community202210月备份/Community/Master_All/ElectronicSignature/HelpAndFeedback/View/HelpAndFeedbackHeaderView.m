//
//  HelpAndFeedbackHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/1/27.
//

#import "HelpAndFeedbackHeaderView.h"

@interface HelpAndFeedbackHeaderView ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation HelpAndFeedbackHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 60);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleL];
        [self addSubview:self.feedbackBtn];
        [self addSubview:self.lineView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_titleL.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
    [_feedbackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(_titleL);
        make.width.offset(80);
        make.height.offset(30);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lineView.superview).offset(16);
        make.right.equalTo(_lineView.superview).offset(-16);
        make.bottom.equalTo(_lineView.superview);
        make.height.offset(0.5);
    }];
}
 
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = FontSize_ElectronicSignature_Bold(16);
        _titleL.text = @"问题反馈";
        _titleL.textColor = [ZYThemeManager shareManager].titleThemeColor;
    }
    return _titleL;
}
- (UIButton *)feedbackBtn{
    if (!_feedbackBtn) {
        _feedbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_feedbackBtn setTitle:@"立即反馈" forState:UIControlStateNormal];
        _feedbackBtn.titleLabel.font = [UIFont systemFontOfSize:13.5];
        [_feedbackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _feedbackBtn.layer.cornerRadius = 15;//h 30
        _feedbackBtn.layer.masksToBounds = YES;
        CGSize size = CGSizeMake(80, 30);//
        _feedbackBtn.backgroundColor = [[ZYThemeManager shareManager] electronicBottomGradientColorWithSize:size];
    }
    return _feedbackBtn;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    }
    return _lineView;
}
@end
