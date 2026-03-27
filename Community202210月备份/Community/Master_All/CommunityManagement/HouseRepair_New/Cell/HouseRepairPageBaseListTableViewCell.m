//
//  HouseRepairPageBaseListTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/4.
//

#import "HouseRepairPageBaseListTableViewCell.h"
#define statusBtn_W 40

@interface HouseRepairPageBaseListTableViewCell ()

@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *topLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *detailInfoLabel;
@property (nonatomic,strong) UIButton *statusBtn;


@end


@implementation HouseRepairPageBaseListTableViewCell

- (void)fillDataWithModel:(MyRepairPageListUseModel *)model{
    DLog(@"");
   NSString *imgF =  [TextShowWithModelStr textShowWithNotNullStr:model.repairImgs.firstObject];
    [self.imgV sd_setImageWithURL:[UrlWithString getURLWithStr:imgF] placeholderImage:[UIImage imageNamed:@"Repair_picture_icon"]];
    self.topLabel.text = [TextShowWithModelStr textShowWithNotNullStr:model.updateTime];
    self.typeLabel.text = [TextShowWithModelStr textShowWithNotNullStr:model.typeName];
    self.detailInfoLabel.text = [TextShowWithModelStr textShowWithNotNullStr:model.problem];
    [self.statusBtn newAnBtnWithTextStr:[TextShowWithModelStr textShowWithNotNullStr:model.statusStr]];
    
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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        self.backView.layer.cornerRadius = 10;
        [self.backView addSubview:self.topLabel];
        [self.backView addSubview:self.typeLabel];
        [self.backView addSubview:self.detailInfoLabel];
        [self.backView addSubview:self.lineView];
        [self.backView addSubview:self.statusBtn];
        [self.backView addSubview:self.lineView];
        [self.backView addSubview:self.imgV];
        [self setUI];
  
    }
    return  self;
}
 
- (void)setUI{ 
  
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topLabel.superview.mas_top).offset(15);
        make.left.equalTo(_topLabel.superview.mas_left).offset(10);
        make.right.equalTo(_topLabel.superview.mas_right).offset(-10-statusBtn_W);
        make.height.offset(20);
    }];
    [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {//statusBtn_W
        make.centerY.equalTo(_topLabel.mas_centerY);
        make.left.equalTo(_topLabel.mas_right).offset(1);
        make.right.equalTo(_topLabel.superview.mas_right).offset(-10);
        make.height.offset(30);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topLabel.mas_bottom).offset(10);
        make.left.equalTo(_lineView.superview.mas_left).offset(10);
        make.right.equalTo(_lineView.superview.mas_right).offset(-10);
        make.height.offset(1);
    }];
    //
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) { 
        make.top.equalTo(_lineView.mas_bottom).offset(20);
        make.left.equalTo(_imgV.superview.mas_left).offset(10);
        make.height.offset(55);
        make.width.offset(55);
    }];
    //
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV);
        make.left.equalTo(_imgV.mas_right).offset(5);
        make.right.equalTo(_typeLabel.superview.mas_right).offset(-10);
        make.height.offset(20);
    }];
    [_detailInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeLabel.mas_bottom).offset(3);
        make.left.equalTo(_imgV.mas_right).offset(5);
        make.right.equalTo(_typeLabel.superview.mas_right).offset(-10);
        make.bottom.lessThanOrEqualTo(_imgV.mas_bottom);
    }];
    [_imgV zy_cornerRadiusAdvance:3 rectCornerType:UIRectCornerAllCorners];

}
 
#pragma mark ==
- (UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc]init];
        _topLabel.font = [UIFont systemFontOfSize:12];
        _topLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _topLabel.numberOfLines = 1;
    }
    return _topLabel;
}
- (UIButton *)statusBtn{
    if (!_statusBtn) {
        _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _statusBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_statusBtn setTitleColor:Color_Blue forState:UIControlStateNormal];//蓝色
    }
    return _statusBtn;
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
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
//        _imgV.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2];
//        _imgV.layer.cornerRadius = 3;
    }
    return _imgV;
}
- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.font = [UIFont boldSystemFontOfSize:14];
        _typeLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _typeLabel.numberOfLines = 1;
    }
    return _typeLabel;
}
- (UILabel *)detailInfoLabel{
    if (!_detailInfoLabel) {
        _detailInfoLabel = [[UILabel alloc]init];
        _detailInfoLabel.font = [UIFont systemFontOfSize:12];
        _detailInfoLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _detailInfoLabel.numberOfLines = 2;
    }
    return _detailInfoLabel;
}
@end
