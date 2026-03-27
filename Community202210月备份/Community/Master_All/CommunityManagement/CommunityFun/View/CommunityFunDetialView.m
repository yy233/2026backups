//
//  CommunityFunDetialView.m
//  Community
//
//  Created by 余莹 on 2020/12/22.
//

#import "CommunityFunDetialView.h"

@interface CommunityFunDetialView ()
@property (nonatomic,strong) UILabel *titiLabel;
@property (nonatomic,strong) UIView *smailLabelBackView;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *redCountLabel;
@property (nonatomic,strong) UIButton *forwardingBtn;
@property (nonatomic,strong) UIView *smailLabelsBottomLineView;
@property (nonatomic,strong) UITextView *contentTextView;
@end
@implementation CommunityFunDetialView

- (void)forwardingBtnAction{
    self.forwardingBtnActionBlock();
}
- (instancetype)initWithFrame:(CGRect)frame{
   self =  [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titiLabel];
        [self addSubview:self.smailLabelBackView];
        [self.smailLabelBackView addSubview:self.timeLabel];
        [self.smailLabelBackView addSubview:self.redCountLabel];
        [self.smailLabelBackView addSubview:self.forwardingBtn];
        [self addSubview:self.smailLabelsBottomLineView];
        [self addSubview:self.contentTextView];
        [self setUI];
    }
    return self;
}
- (void)setModel:(CommunityFunModel *)model{
    _model = model;
    _contentTextView.text = model.content;
    [self titleTextShow];
    [self timeTextShow];
    [self redCountShow];
}
- (void)titleTextShow{
    _titiLabel.text = _model.titleName;
    NSInteger titleHeight = [_model gettitleLabelShowHeight];
    if (titleHeight>Screen_H*0.3) {//限制高度
        titleHeight=Screen_H*0.3;
        _titiLabel.font = [UIFont boldSystemFontOfSize:15];
    }else{
        _titiLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    [_titiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titiLabel.superview.mas_top).offset(15);
        make.width.equalTo(_titiLabel.superview.mas_width).offset(-32);
        make.centerX.equalTo(_titiLabel.superview.mas_centerX);
        make.height.offset(titleHeight);
    }];
}
- (void)timeTextShow{
    NSString *timeStr = [ToolOfTimeChangeFormat urgentListTimeFormatWithStr:_model.createTime];
    _timeLabel.text = timeStr;
}
- (void)redCountShow{
    NSString *redCountStr = [NSString stringWithFormat:@"浏览次数：%ld",(long)_model.viewCount];//
    _redCountLabel.text = redCountStr;
}
#pragma mark ==
- (void)setUI{
    [_titiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titiLabel.superview.mas_top).offset(15);
        make.width.equalTo(_titiLabel.superview.mas_width).offset(-32);
        make.centerX.equalTo(_titiLabel.superview.mas_centerX);
        make.height.offset(20);
    }];
    //
    [_smailLabelBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titiLabel.mas_bottom).offset(5);
        make.centerX.equalTo(_smailLabelBackView.superview.mas_centerX);
        make.width.equalTo(_smailLabelBackView.superview.mas_width).offset(-32);
        make.height.offset(30);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeLabel.superview.mas_centerY);
        make.left.equalTo(_timeLabel.superview.mas_left).offset(10);
        make.height.equalTo(_timeLabel.superview.mas_height);
        make.width.offset(70);
    }];
    [_redCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_redCountLabel.superview.mas_centerY);
        make.left.equalTo(_timeLabel.mas_right).offset(5);
        make.height.equalTo(_redCountLabel.superview.mas_height);
        make.width.offset(120);
    }];
    [_forwardingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_forwardingBtn.superview.mas_centerY);
        make.right.equalTo(_forwardingBtn.superview.mas_right).offset(-10);
        make.height.equalTo(_forwardingBtn.superview.mas_height);
        make.width.offset(60);
    }];
    //
    [_smailLabelsBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_smailLabelBackView.mas_bottom).offset(15);
        make.width.equalTo(_contentTextView.superview.mas_width).offset(-32);
        make.centerX.equalTo(_contentTextView.superview.mas_centerX);
        make.height.offset(1);
    }];
    //
    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_smailLabelsBottomLineView.mas_bottom).offset(5);
        make.width.equalTo(_contentTextView.superview.mas_width).offset(-32);
        make.centerX.equalTo(_contentTextView.superview.mas_centerX);
        make.bottom.equalTo(_contentTextView.superview.mas_bottom).offset(-20);
    }];
}
#pragma mark ==
- (UILabel *)titiLabel{
    if (!_titiLabel) {
        _titiLabel = [[UILabel alloc]init];
        _titiLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _titiLabel.font = [UIFont boldSystemFontOfSize:18];
        _titiLabel.textAlignment = NSTextAlignmentLeft;
        _titiLabel.numberOfLines = 0;
    }
    return _titiLabel;
}
- (UIView *)smailLabelBackView{
    if (!_smailLabelBackView) {
        _smailLabelBackView = [[UIView alloc]init];
        _smailLabelBackView.backgroundColor = [ThemeManager shareManager].mainContentBackgroundColor;
        _smailLabelBackView.layer.cornerRadius = 5;
    }
    return _smailLabelBackView;
}
- (UIButton *)forwardingBtn{
    if (!_forwardingBtn) {
        _forwardingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forwardingBtn setTitle:@"转发" forState:UIControlStateNormal];
        [_forwardingBtn newAnBtnWithImg:[UIImage imageNamed:@"Interestingevents_Details_Share_night"]];
        [_forwardingBtn setTitleColor:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
        _forwardingBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_forwardingBtn addTarget:self action:@selector(forwardingBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_forwardingBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    }
    return _forwardingBtn;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}
- (UILabel *)redCountLabel{
    if (!_redCountLabel) {
        _redCountLabel = [[UILabel alloc]init];
        _redCountLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _redCountLabel.font = [UIFont systemFontOfSize:12];
        _redCountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _redCountLabel;
}
- (UITextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView  = [[UITextView alloc]init];
        _contentTextView.editable = NO;
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.textColor = [ThemeManager shareManager].mainTextColor;
        _contentTextView.font = [UIFont systemFontOfSize:14];
        
    }
    return _contentTextView;
}
- (UIView *)smailLabelsBottomLineView{
    if (!_smailLabelsBottomLineView) {
        _smailLabelsBottomLineView = [[UIView alloc]init];
        _smailLabelsBottomLineView.backgroundColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.1];
    }
    return _smailLabelsBottomLineView;
}

@end
