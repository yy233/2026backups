//
//  MyEditHouseTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/8/4.
//

#import "MyEditHouseTableViewCell.h"

@implementation MyEditHouseTableViewCell

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
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
//        self.backView.backgroundColor = Color_11BlueColor;
        self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.detailL];
        [self setUI];
    }
    return self;
}
- (void)prepareForReuse{
    [super prepareForReuse];
    self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL.superview).offset(16);
        make.top.bottom.equalTo(_titleL.superview);
        make.width.offset(90);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL.mas_right);
        make.top.bottom.equalTo(_titleL);
        make.right.equalTo(_detailL.superview).offset(-16);
    }];
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont systemFontOfSize:15];
    }
    _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    return _titleL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.font = [UIFont systemFontOfSize:15];
        _detailL.textAlignment = NSTextAlignmentRight;
        _detailL.numberOfLines = 3;
    }
    _detailL.textColor = [ThemeManager shareManager].mainTextColor;

    return _detailL;
}

@end
