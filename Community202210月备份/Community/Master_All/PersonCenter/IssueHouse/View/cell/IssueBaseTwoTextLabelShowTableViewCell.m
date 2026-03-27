//
//  IssueBaseTwoTextLabelShowTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/22.
//

#import "IssueBaseTwoTextLabelShowTableViewCell.h"
#define Color_TopText            ([ThemeManager shareManager].type == ThemeType_White ? Y_RGBA(153, 153, 153, 1) : Y_RGBA(172, 172, 172, 1))
@interface IssueBaseTwoTextLabelShowTableViewCell ()
@property (nonatomic,strong) UIView *backV;
@property (nonatomic,strong) UILabel *topLabel;
@end
@implementation IssueBaseTwoTextLabelShowTableViewCell

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
        self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        [self.contentView addSubview:self.backV];
        [self.backV addSubview:self.topLabel];
        [self.backV addSubview:self.concentLabel];
        [self setUI];
        [self setUIOfNewTitles];//用于子类重写
    }
    return self;
}
- (void)setUIOfNewTitles{
    self.topLabel.text = @"卧室类型";
}
- (void)setUI{
    [_backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backV.superview);
    }];
    //
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topLabel.superview.mas_top);
        make.left.equalTo(_topLabel.superview.mas_left);
        make.right.equalTo(_topLabel.superview.mas_right);
        make.height.equalTo(_topLabel.superview.mas_height).multipliedBy(0.3);
   
    }];
    [_concentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topLabel.mas_bottom);
        make.left.equalTo(_concentLabel.superview.mas_left);
        make.right.equalTo(_concentLabel.superview.mas_right);
        make.height.equalTo(_concentLabel.superview.mas_height).multipliedBy(0.7);
    }];
}
#pragma mark ==
- (UIView *)backV{
    if (!_backV) {
        _backV = [[UIView alloc]init];
    }
    return _backV;
}
- (UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc]init];
        _topLabel.font = [UIFont systemFontOfSize:12];
        _topLabel.textColor = Color_TopText;
        _topLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topLabel;
}
//
- (UILabel *)concentLabel{
    if (!_concentLabel) {
        _concentLabel = [[UILabel alloc]init];
        _concentLabel.font = [UIFont boldSystemFontOfSize:18];
        _concentLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _concentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _concentLabel;
}
@end
