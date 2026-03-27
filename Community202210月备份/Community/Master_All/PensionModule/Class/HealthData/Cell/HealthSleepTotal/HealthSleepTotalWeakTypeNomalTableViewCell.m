//
//  HealthSleepTotalWeakTypeNomalTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/11/18.
//

#import "HealthSleepTotalWeakTypeNomalTableViewCell.h"

@implementation HealthSleepTotalWeakTypeNomalTableViewCell

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
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.detailL];
        [self setBaseUI];
    }
    return self;
}
- (void)setBaseUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(_titleL.superview);
        make.left.equalTo(_titleL.superview.mas_left).offset(26);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(_detailL.superview);
        make.right.equalTo(_detailL.superview.mas_right).offset(-26);
    }];
}

#pragma mark ==
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font =  [PensionThemeManager shareManager].Pension_TextFont_13;
        _titleL.textColor = Color_51BlackColor;
        _titleL.textAlignment = NSTextAlignmentLeft;
    }
    return _titleL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.font =  [PensionThemeManager shareManager].Pension_TextFont_13;
        _detailL.textColor = Color_51BlackColor;
        _detailL.textAlignment = NSTextAlignmentRight;
    }
    return _detailL;
}
@end

@implementation HealthSleepTotalOnlyTextTableViewCell 
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.contentTextView];
        [self setBaseUI];
    }
    return self;
}
- (void)setBaseUI{
    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contentTextView.superview).insets(UIEdgeInsetsMake(10, 26, 10, 26));
    }];
}
- (UITextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView  = [[UITextView alloc]init];
        _contentTextView.textColor = Color_51BlackColor;
        _contentTextView.font = [PensionThemeManager shareManager].Pension_TextFont_13;
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.editable = NO;
    }
    return _contentTextView;
}
@end
