//
//  IssueHouseManagerVcTopTwoBtnsTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/19.
//

#import "IssueHouseManagerVcTopTwoBtnsTableViewCell.h"

@implementation IssueHouseManagerVcTopTwoBtnsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backView.backgroundColor = [UIColor clearColor];
        //
        [self.backView addSubview:self.yuyueBtn];
        [self.backView addSubview:self.qianyueBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_yuyueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_yuyueBtn.superview);
        make.right.equalTo(_yuyueBtn.superview.mas_centerX).offset(-5);
    }];
    [_qianyueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(_yuyueBtn.superview);
        make.left.equalTo(_qianyueBtn.superview.mas_centerX).offset(5);
    }];
}
- (UIButton *)yuyueBtn{
    if (!_yuyueBtn) {
        _yuyueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _yuyueBtn.backgroundColor = [UIColor whiteColor];
        _yuyueBtn.layer.cornerRadius = 7.5;
        [_yuyueBtn newAnBtnWithImg:[UIImage imageNamed:@"Landlord_BookingManagement"]];
        [_yuyueBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:15]];
        [_yuyueBtn newAnBtnWithTextStr:@"预约管理"];
        [_yuyueBtn newAnBtnWithTextColor:[UIColor blackColor]];
        [_yuyueBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [_yuyueBtn addTarget:self action:@selector(yuyueBtnAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _yuyueBtn;
}
- (UIButton *)qianyueBtn{
    if (!_qianyueBtn) {
        _qianyueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _qianyueBtn.backgroundColor = [UIColor whiteColor];
        _qianyueBtn.layer.cornerRadius = 7.5;
        [_qianyueBtn newAnBtnWithImg:[UIImage imageNamed:@"Landlord_Contractmanagement"]];
        [_qianyueBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:15]];
        [_qianyueBtn newAnBtnWithTextStr:@"签约管理"];
        [_qianyueBtn newAnBtnWithTextColor:[UIColor blackColor]];
        [_qianyueBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [_qianyueBtn addTarget:self action:@selector(qianyueBtnAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _qianyueBtn;
}
#pragma mark==
- (void)yuyueBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(cellTouchYuyueAction)]) {
        [_delegate cellTouchYuyueAction];
        
    }
}
- (void)qianyueBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(cellTouchQianyueAction)]) {
        [_delegate cellTouchQianyueAction];
        
    }
}
@end
