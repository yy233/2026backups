//
//  HouseRentDetailBuniessShopIntroducedCell.m
//  Community
//
//  Created by 余莹 on 2021/1/8.
//

#import "HouseRentDetailBuniessShopIntroducedCell.h"
@interface HouseRentDetailBuniessShopIntroducedCell ()
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *contentL;
@end
@implementation HouseRentDetailBuniessShopIntroducedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HouseRentDetailVcBuniessShopModelShopModel *)model{
    _model = model;
    _contentL.text = [TextShowWithModelStr textShowWithModelStr:model.summarize];
    CGFloat h = [_model getBuniessCellIntroduceHeight];
    [self upContentLabelH:h];
}
- (void)upContentLabelH:(CGFloat)h{
    [_contentL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(h);//高度
    }];
}
#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor =  [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.contentL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview.mas_top).offset(10);
        make.left.equalTo(_titleL.superview.mas_left).offset(16);
        make.right.equalTo(_titleL.superview.mas_right).offset(-16);
        make.height.offset(20);
    }];
    [_contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom);
        make.left.equalTo(_contentL.superview.mas_left).offset(16);
        make.right.equalTo(_contentL.superview.mas_right).offset(-16);
        make.height.offset(20);//初始高度
    }];
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont boldSystemFontOfSize:17];
        _titleL.text = @"房屋介绍";
    }
    return _titleL;
}
- (UILabel *)contentL{
    if (!_contentL) {
        _contentL = [[UILabel alloc]init];
        _contentL.textColor = [ThemeManager shareManager].mainTextColor;
        _contentL.font = [UIFont systemFontOfSize:14];
        _contentL.text = @"";
        _contentL.numberOfLines = 0;
    }
    return _contentL;
}
@end
