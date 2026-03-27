//
//  LifeCostPaymentDetailsListOneTimeShowTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/11.
//

#import "LifeCostPaymentDetailsListOneRowTimeShowTableViewCell.h"

@implementation LifeCostPaymentDetailsListOneRowTimeShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    //    UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 40)];
    //    UILabel *sectionHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, 0, Screen_W-52, 20)];
    //    sectionHeaderLabel.text = @"2020年x月";
    //    sectionHeaderLabel.textColor = [ThemeManager shareManager].mainTextColor;
    //    sectionHeaderLabel.font = [UIFont boldSystemFontOfSize:15];
    //    [backV addSubview:sectionHeaderLabel];
#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleTiemShowL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleTiemShowL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleTiemShowL.superview.mas_centerY);
        make.left.equalTo(_titleTiemShowL.superview.mas_left).offset(26);
        make.right.equalTo(_titleTiemShowL.superview.mas_right).offset(-26);
        make.height.offset(20);
    }];
}
#pragma mark ===
 
- (UILabel *)titleTiemShowL{
    if (!_titleTiemShowL) {
        _titleTiemShowL = [[UILabel alloc]init];
        _titleTiemShowL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleTiemShowL.font = [UIFont boldSystemFontOfSize:15];
    }
    return _titleTiemShowL;
}
 
    
@end
