//
//  BillingListVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/6/8.
//

#import "BillingListVcTableViewCell.h"

static NSString *k_wyfImg = @"sq_wyjf";//物业缴费
static NSString *k_tingcarImg = @"sq_lstc";//临时停车
static NSString *k_yuezuImg = @"sq_yzjf";//月租缴费


@implementation BillingListVcTableViewCell

- (void)fillModel:(BillingListSubOneInfoDetailModel *)model{
    
    [self.imgV sd_setImageWithURL:[UrlWithString getURLWithStr:model.subHeadImgUrl] placeholderImage:Main_PlaceholderImg_WeqH];
    self.typeL.text = [TextShowWithModelStr textShowWithModelStr:model.subName];
    self.timeL.text = [TextShowWithModelStr textShowWithModelStr:model.payTime];
    self.moneyL.text = [NSString stringWithFormat:@"%0.2f",model.amount];
    self.barkmoneyL.text = [NSString stringWithFormat:@"已退款%0.2f",0.0];
    self.barkmoneyL.hidden = YES;//暂无退款类型 暂时隐藏
}
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
        WEAKSELF
        [weakSelf.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.backView.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
       // weakSelf.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.backView addSubview:self.imgV];
        [self.backView addSubview:self.typeL];
        [self.backView addSubview:self.timeL];
        [self.backView addSubview:self.moneyL];
        [self.backView addSubview:self.barkmoneyL];
      
        [self setCellUI];
    }
    return self;
}
- (void)setCellUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(35);
        make.centerY.equalTo(_imgV.superview);
        make.left.equalTo(_imgV.superview).offset(16);
    }];
    
    [_typeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(_imgV.mas_right).offset(15);
        make.right.equalTo(_typeL.superview).offset(-120);
        make.top.equalTo(_imgV);
    }];
    
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeL.mas_bottom);
        make.left.right.height.equalTo(_typeL);
    }];
    
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(_typeL);
        make.right.equalTo(_moneyL.superview).offset(-16);
    }];
    
    [_barkmoneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.right.equalTo(_moneyL);
        make.centerY.equalTo(_timeL);
    }];
}

#pragma mark ==
- (UILabel *)typeL{
    if (!_typeL) {
        _typeL = [[UILabel alloc]init];
        _typeL.textColor = [ThemeManager shareManager].mainTextColor;
        _typeL.font = [UIFont systemFontOfSize:15.0];
    }
    return _typeL;
}
- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.textColor = [ThemeManager shareManager].mainTextColor;
        _timeL.font = [UIFont systemFontOfSize:12.0];
    }
    return _timeL;
}
- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.textColor = [ThemeManager shareManager].mainTextColor;
        _moneyL.font = [UIFont systemFontOfSize:15.0];
    }
    return _moneyL;
}
- (UILabel *)barkmoneyL{
    if (!_barkmoneyL) {
        _barkmoneyL = [[UILabel alloc]init];
        _barkmoneyL.textColor = Y_ColorWith16FromRGB(0xFF3A3A);
        _barkmoneyL.font = [UIFont systemFontOfSize:12.0];
    }
    return _barkmoneyL;
}

- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgV;
}
@end
