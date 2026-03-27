//
//  MyCarWithParkingSpotListVcNomalShowInfoTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/5/6.
//

#import "MyCarWithParkingSpotListVcNomalShowInfoTableViewCell.h"
static CGFloat kCellSubConentViewUseJianJu = 16.0;

@interface MyCarWithParkingSpotListVcNomalShowInfoTableViewCell ()

@property (nonatomic,strong) UIView *topLayerView;
@property (nonatomic,strong) UILabel *carPlateL;
@property (nonatomic,strong) UILabel *spotShopCarTypeL;
@property (nonatomic,strong) UILabel *communitySpotNameL;
@property (nonatomic,strong) UILabel *spotStuteL;
@property (nonatomic,strong) UIImageView *spotStuteImg;


@end


@implementation MyCarWithParkingSpotListVcNomalShowInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillModel:(MyCarWithParkingSpotModel *)model{

    self.carPlateL.text = model.carPositionNumber;
    self.communitySpotNameL.text = model.siteClassificationName;
    self.spotShopCarTypeL.text = model.classificationName;
    self.spotStuteL.text = ( model.carPosStatus > 1)? @"月租" : @"产权";//1产权，2租赁
    self.spotStuteImg.image = ( model.carPosStatus > 1) ? [UIImage imageNamed:@"yz_icon"] : [UIImage imageNamed:@"cq_icon"];
//    self.spotStuteImg.backgroundColor =  model.parkingSpotIsMonthTypeBool ?  [UIColor orangeColor] : [UIColor brownColor];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.topLayerView];//遮挡圆角用到的view
        [self.backView addSubview:self.spotStuteImg];
        [self.backView addSubview:self.spotStuteL];
        [self.backView addSubview:self.carPlateL];
        [self.backView addSubview:self.spotShopCarTypeL];
        [self.backView addSubview:self.communitySpotNameL];
        [self setBaseUI];
        [self bringSubviewToFront:self.topLayerView];
        [self.backView.superview bringSubviewToFront:self.backView];  //superview做层级更改 把backView推到前边 使得topLayerView到backView之下
    }
    return self;
}
- (void)setBaseUI{
    self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;

    WEAKSELF
    [_topLayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topLayerView.superview).offset(5);
        make.height.offset(20);
        make.left.equalTo(_topLayerView.superview).offset(kCellSubConentViewUseJianJu);
        make.right.equalTo(_topLayerView.superview).offset(-kCellSubConentViewUseJianJu);
    }];
    
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topLayerView.mas_top).offset(10);
        make.left.right.equalTo(_topLayerView);
        make.bottom.equalTo(weakSelf.backView.superview);
        
    }];
    
    
    [_carPlateL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_carPlateL.superview).offset(10);
        make.height.offset(30);
        make.left.equalTo(_carPlateL.superview).offset(16);
    }];
    
    [_spotShopCarTypeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(_carPlateL);
        make.left.equalTo(_carPlateL.mas_right).offset(10);
    }];
    
    [_communitySpotNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_carPlateL.mas_bottom).offset(5);
        make.left.equalTo(_carPlateL);
        make.height.offset(20);
        make.right.lessThanOrEqualTo(_communitySpotNameL.superview);
    }];
    
    [_spotStuteImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topLayerView).offset(-5);
        make.right.equalTo(_spotStuteImg.superview).offset(-20);
        make.width.offset(30);
        make.height.offset(36);
    }];
    [_spotStuteL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.width.equalTo(_spotStuteImg);
        make.height.offset(20);
    }];
    
}
 

#pragma mark ==
- (UIView *)topLayerView{
    if (!_topLayerView) {
        _topLayerView = [[UIView alloc]init];
        _topLayerView.clipsToBounds = YES;
        _topLayerView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        _topLayerView.layer.cornerRadius = 10.0;

    }
    return _topLayerView;
}


- (UILabel *)carPlateL{
    if (!_carPlateL) {
        _carPlateL = [[UILabel alloc]init];
        _carPlateL.textColor = [ThemeManager shareManager].mainTextColor; 
        _carPlateL.font = [UIFont boldSystemFontOfSize:28.0];
    }
    return _carPlateL;
}
 
- (UILabel *)spotShopCarTypeL{
    if (!_spotShopCarTypeL) {
        _spotShopCarTypeL =  [[UILabel alloc]init];
        _spotShopCarTypeL.textColor =  [ThemeManager shareManager].mainTextColor;//Color_Red;
        _spotShopCarTypeL.font = [UIFont boldSystemFontOfSize:15.0];
    }
    return _spotShopCarTypeL;
}

- (UILabel *)communitySpotNameL{
   if (!_communitySpotNameL) {
       _communitySpotNameL = [[UILabel alloc]init];
       _communitySpotNameL.textColor =  [ThemeManager shareManager].mainTextColor;
       _communitySpotNameL.font = [UIFont systemFontOfSize:14.0];
   }
   return _communitySpotNameL;
}

- (UILabel *)spotStuteL{
   if (!_spotStuteL) {
       _spotStuteL = [[UILabel alloc]init];
       _spotStuteL.textColor = [UIColor whiteColor];
       _spotStuteL.font = [UIFont systemFontOfSize:12.0];
       _spotStuteL.textAlignment = NSTextAlignmentCenter;
   }
   return _spotStuteL;
}

- (UIImageView *)spotStuteImg{
   if (!_spotStuteImg) {
       _spotStuteImg = [[UIImageView alloc]init];
       _spotStuteImg.contentMode = UIViewContentModeScaleAspectFit;
   }
   return _spotStuteImg;
}
@end
