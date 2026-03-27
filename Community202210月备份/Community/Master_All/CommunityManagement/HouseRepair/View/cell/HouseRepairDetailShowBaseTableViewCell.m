//
//  HouseRepairDetailShowBaseTableViewCell.m
//  Community
//
//  Created by 余莹 on 2020/12/25.
//

#import "HouseRepairDetailShowBaseTableViewCell.h"
#define statusBtn_W 40
#define bottomBtn_W 75
@implementation HouseRepairDetailShowBaseTableViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;//
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.lineView];
        [self setUI];
    }
    return  self;
}
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(5, 16, 5, 16));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.superview.mas_top).offset(15);
        make.left.equalTo(_titleLabel.superview.mas_left).offset(10);
        make.right.equalTo(_titleLabel.superview.mas_right).offset(-10-statusBtn_W);
        make.height.offset(20);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(_lineView.superview.mas_left).offset(10);
        make.right.equalTo(_lineView.superview.mas_right).offset(-10);
        make.height.offset(1);
    }];
}
#pragma mark ==
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
        _backView.layer.cornerRadius = 10;
    }
    return _backView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
      
        if ([ThemeManager shareManager].type==ThemeType_White) {
            _lineView.backgroundColor = Y_RGBA(240, 241, 246, 1);
        }else{
            _lineView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
        }
    }
    return _lineView;
}
@end
