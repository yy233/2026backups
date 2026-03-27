//
//  PackingPayHistoryVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/5/9.
//

#import "PackingPayHistoryVcTableViewCell.h"

@interface PackingPayHistoryVcTableViewCell ()
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *mainInfoLabel;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *moneyLabel;

@end

@implementation PackingPayHistoryVcTableViewCell
- (void)fillModel:(PackingPayHistoryModel *)model{
    if (model.groundUpAndDown == 1) {   // 0地上1地下   地上展示车位号 地下展示车牌号
        self.imgV.image = [UIImage imageNamed:@"chewei_icon"];
        self.mainInfoLabel.text = [TextShowWithModelStr textShowWithModelStr:model.carPositionNumber];//车牌号
    }else{
        self.imgV.image = [UIImage imageNamed:@"cheliang_icon"];
        self.mainInfoLabel.text = [TextShowWithModelStr textShowWithModelStr:model.carNumber];//车位号
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"¥ %0.2f",model.payMoney];
    self.timeLabel.text = [TextShowWithModelStr textShowWithModelStr:model.payTime];//@"购买付钱相关的时间";
    self.addressLabel.text =  [TextShowWithModelStr textShowWithModelStr:model.siteClassificationName];//车场
    self.addressLabel.hidden = YES;
}
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
        WEAKSELF
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
        self.backView.layer.cornerRadius = 15;
        self.backView.layer.masksToBounds = YES;
        self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.backView addSubview:self.imgV];
        [self.backView addSubview:self.mainInfoLabel];
        [self.backView addSubview:self.addressLabel];
        [self.backView addSubview:self.timeLabel];
        [self.backView addSubview:self.moneyLabel];
        [self setBaseUI];
    }
    return self;
}
- (void)setBaseUI{
    
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgV.superview);
        make.height.width.offset(45);
        make.left.equalTo(_imgV.superview).offset(20);
    }];
    [_mainInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV.mas_right).offset(10);
        make.top.equalTo(_imgV);
        make.height.offset(20);
        make.right.lessThanOrEqualTo(_mainInfoLabel.superview).offset(-100);
    }];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainInfoLabel.mas_bottom).offset(5);
        make.right.left.equalTo(_mainInfoLabel);
        //make.height.offset(32);
        make.height.offset(1);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_imgV).offset(0);
        make.height.right.left.equalTo(_mainInfoLabel);
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_moneyLabel.superview);
        make.height.offset(20);
        make.right.equalTo(_moneyLabel.superview).offset(-15);
    }];
}


#pragma mark ===

- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgV;
}
- (UILabel *)mainInfoLabel{
    if (!_mainInfoLabel) {
        _mainInfoLabel = [[UILabel alloc]init];
        _mainInfoLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _mainInfoLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _mainInfoLabel;
}
- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.font = [UIFont systemFontOfSize:13.0];
        _addressLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _addressLabel.numberOfLines = 2;
    }
    return _addressLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        _timeLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _timeLabel;
}
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _moneyLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
}
@end
