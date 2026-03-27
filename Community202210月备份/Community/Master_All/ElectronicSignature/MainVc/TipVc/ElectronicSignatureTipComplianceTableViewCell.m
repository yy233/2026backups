//
//  ElectronicSignatureTipComplianceTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/27.
//

#import "ElectronicSignatureTipComplianceTableViewCell.h"

@implementation ElectronicSignatureTipComplianceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.detailTextBackView];
        [self.detailTextBackView addSubview:self.detailL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview).offset(10);
        make.height.offset(50);
        make.left.equalTo(_titleL.superview.mas_left).offset(16);
        make.right.equalTo(_titleL.superview.mas_right).offset(-16);
    }];
    [_detailTextBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_detailTextBackView.superview).insets(UIEdgeInsetsMake(72, 10, 12, 10));//h 20+空5空5
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_detailTextBackView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

- (UIView *)detailTextBackView{
    if (!_detailTextBackView) {
        _detailTextBackView = [[UIView alloc]init];
        _detailTextBackView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_Lf0f1f6;
        _detailTextBackView.layer.cornerRadius = 5;
        _detailTextBackView.layer.masksToBounds = YES;
    }
    return _detailTextBackView;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.textColor = [ZYThemeManager shareManager].titleThemeColor;
        _titleL.font = FontSize_ElectronicSignature_Bold(20);
         
    }
    return _titleL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.textAlignment = NSTextAlignmentLeft;
        _detailL.textColor =  [ZYThemeManager shareManager].subTitleThemeColor;
        _detailL.font = FontSize_ElectronicSignature_Nomail(15);
        _detailL.numberOfLines = 0;
    }
    return _detailL;
}
@end
