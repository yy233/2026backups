//
//  LifeCostContWillPayMainTitleImgTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/1/8.
//

#import "LifeCostContWillPayMainTitleImgTableViewCell.h"

@implementation LifeCostContWillPayMainTitleImgTableViewCell

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
        [self.contentView addSubview:self.imgV];
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.lineV];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_imgV.superview);
        make.height.width.offset(85);
     }];
    
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.bottom.equalTo(_titleL.superview);
        make.top.equalTo(_imgV.mas_bottom);
    }];
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.equalTo(_titleL.mas_left).offset(15);
        make.right.equalTo(_titleL.mas_right).offset(-15);
        make.bottom.equalTo(_lineV.superview);
    }];
   
}
#pragma mark ===
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV.image = [UIImage imageNamed:@"zanweiqianfei"];
    }
    return _imgV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont boldSystemFontOfSize:18.0];
        _titleL.text = @"暂未查询到欠费";
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL;
}
- (UILabel *)lineV{
    if (!_lineV) {
        _lineV = [[UILabel alloc]init];
        _lineV.backgroundColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.15];
    }
    return _lineV;
}

@end
