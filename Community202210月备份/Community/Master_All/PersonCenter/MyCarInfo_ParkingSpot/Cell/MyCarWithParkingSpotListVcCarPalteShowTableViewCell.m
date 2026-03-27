//
//  MyCarWithParkingSpotListVcCarPalteShowTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/5/6.
//

#import "MyCarWithParkingSpotListVcCarPalteShowTableViewCell.h"
#import "MyCarWithParkingSpotHeader.h"

#pragma mark ==  仅供展示的车牌UI
@interface MyCarWithParkingSpotListVcCarPalteShowTableViewCell ()
@end

@implementation MyCarWithParkingSpotListVcCarPalteShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillCarPlateStr:(NSString *)carPstr{
    self.carPlateL.text = carPstr;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        WEAKSELF
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.backView.superview).insets(UIEdgeInsetsMake(0, kMyCarSpotListCellSubConentViewUseJianJu16, 0, kMyCarSpotListCellSubConentViewUseJianJu16));
        }];
        self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.backView addSubview:self.carPlateL];
        [self setBaseUI];
    }
    return self;
}
- (void)setBaseUI{
    [_carPlateL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(_carPlateL.superview);
        make.height.equalTo(_carPlateL.superview).offset(-20);
        make.width.equalTo(_carPlateL.superview).offset(-32);
    }];
    

    [self carPlateLOtherUI];

}
- (void)carPlateLOtherUI{
    CGRect carPlateBounds =  CGRectMake(0, 0, Screen_W-(kMyCarSpotListCellSubConentViewUseJianJu16+16)*2, 60-20);//60为cell_h

    CGSize carPlateCornerRadiSize = CGSizeMake(10, 10);
    //上半的圆角
    _carPlateL.layer.mask = [BezierPathTool bezierPathToolWithThisViewBounds:carPlateBounds
                                                              withCornerRadi:carPlateCornerRadiSize
                                                         withRoundingCorners: (UIRectCornerTopLeft | UIRectCornerTopRight)];
}


- (LabelYu *)carPlateL{
    if (!_carPlateL) {
        _carPlateL = [[LabelYu alloc]init];
        _carPlateL.textColor = [UIColor whiteColor];
        _carPlateL.font = [UIFont boldSystemFontOfSize:15.0];
        _carPlateL.backgroundColor = kParkingSpotColor_Green;
        _carPlateL.textInsets = UIEdgeInsetsMake(0, 10, 0, 10);

    }
    return _carPlateL;
}
@end



#pragma mark == 有加按钮的UI


@interface MyCarWithParkingSpotListVcCarPalteNilShowCanAddActionTableViewCell ()



@end

@implementation MyCarWithParkingSpotListVcCarPalteNilShowCanAddActionTableViewCell

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
            make.edges.equalTo(weakSelf.backView.superview).insets(UIEdgeInsetsMake(0, kMyCarSpotListCellSubConentViewUseJianJu16, 0, kMyCarSpotListCellSubConentViewUseJianJu16));
        }];
        self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;

        [self.backView addSubview:self.imgV];
        [self.backView addSubview:self.topBtn];
   
        [self setBaseUI];
    }
    return self;
}
- (void)setBaseUI{
    
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(_imgV.superview);
        make.height.equalTo(_imgV.superview).offset(-20);
        make.width.equalTo(_imgV.superview).offset(-32);
    }];
    [_topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_imgV);
    }];
    [self imgOtherUI];
}
- (void)imgOtherUI{
    
    CGRect carPlateBounds =  CGRectMake(0, 0, Screen_W-(kMyCarSpotListCellSubConentViewUseJianJu16+16)*2, 60-20);//60为cell_h
    CAShapeLayer * border = [BezierPathTool drawDotLineWithThisViewBounds:carPlateBounds
                                                            withLineColor: Y_ColorWith16FromRGB(0xC5C9D4)
                                                            withFillColor:nil
                                                            withLineWidth:1.f
                                                              AndLineType:nil
                                                         withCornerRadius:10.f
                                                      withRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)];
    [self.imgV.layer addSublayer:border];//虚线框
}

- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeCenter;
        _imgV.image = [UIImage imageNamed:@"cheltianjia_icon"];
    }
    return _imgV;
}
- (UIButton *)topBtn{
    if (!_topBtn) {
        _topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topBtn addTarget:self action:@selector(topBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topBtn;
}
- (void)topBtnAction{
    if (isNil(self.touchAddBtnBlock)) {
        return;
    }
    self.touchAddBtnBlock();
}
@end


#pragma mark == 新增加的数据 有删除UI
 
@interface MyCarWithParkingSpotListVcCarPalteCanDeleteTableViewCell ()

@property (nonatomic,strong) UIButton *deletBtn;

@end

@implementation MyCarWithParkingSpotListVcCarPalteCanDeleteTableViewCell


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
        self.carPlateL.textColor = [ThemeManager shareManager].mainTextColor;
        [self.backView addSubview:self.deletBtn];
        [self setDeletUI];
    }
    return self;
}
- (void)setDeletUI{
    WEAKSELF
    [_deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.carPlateL);
        make.width.height.offset(40);
        make.right.equalTo(weakSelf.carPlateL).offset(-10);
    }];
    
    [self editLabelOtherUI];
}
- (void)editLabelOtherUI{
    self.carPlateL.backgroundColor = [UIColor clearColor];
    CGRect carPlateBounds =  CGRectMake(0, 0, Screen_W-(kMyCarSpotListCellSubConentViewUseJianJu16+16)*2, 60-20);//60为cell_h
    CAShapeLayer * border = [BezierPathTool drawDotLineWithThisViewBounds:carPlateBounds
                                                            withLineColor:Y_ColorWith16FromRGB(0xC5C9D4)
                                                            withFillColor:nil
                                                            withLineWidth:1.f
                                                              AndLineType:nil
                                                         withCornerRadius:10.f
                                                      withRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)];
    [self.carPlateL.layer addSublayer:border];//虚线框
    
}
- (UIButton *)deletBtn{
    if (!_deletBtn) {
        _deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deletBtn newAnBtnWithImg:[UIImage imageNamed:@"clsc_icon"]];
        [_deletBtn addTarget:self action:@selector(deletBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deletBtn;
}
- (void)deletBtnAction{
    DLog(@"");
    if (isNil(self.touchDeletBtnBlock)) {
        return;
    }
    self.touchDeletBtnBlock();
}

@end


#pragma mark ==

@interface MyCarWithParkingSpotListVcBottomTableViewCell ()



@property (nonatomic,strong) UIView *bottomUseV;

@end

@implementation MyCarWithParkingSpotListVcBottomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillCarPlateStr:(NSString *)carPstr{
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.bottomUseV];//做圆角用到的view
        [self setBaseUI];
    }
    return self;
}
- (void)setBaseUI{
    [_bottomUseV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomUseV.superview);
        make.left.equalTo(_bottomUseV.superview).offset(kMyCarSpotListCellSubConentViewUseJianJu16);
        make.right.equalTo(_bottomUseV.superview).offset(-kMyCarSpotListCellSubConentViewUseJianJu16);
        make.top.equalTo(_bottomUseV.superview).offset(-10);
    }];

}
- (UIView *)bottomUseV{
    if (!_bottomUseV) {
        _bottomUseV = [[UIView alloc]init];
        _bottomUseV.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        _bottomUseV.layer.cornerRadius = 10.0;
        _bottomUseV.clipsToBounds = YES;
    }
    return _bottomUseV;
}


@end
