//
//  HouseRentTableViewCell.m
//  Community
//
//  Created by 余莹 on 2020/12/29.
//

#import "HouseRentHouseTableViewCell.h"

@interface HouseRentHouseTableViewCell ()
//@property (nonatomic,strong) UIView *backGroundV;
//@property (nonatomic,strong) UIImageView *headImgv;
//@property (nonatomic,strong) UILabel *titleLabel;
//@property (nonatomic,strong) UILabel *detailtitleLabel;
//@property (nonatomic,strong) UILabel *coseL;//费用
//@property (nonatomic,strong) UIView *typeBackView;//类型的backv
//
//@property (nonatomic,strong) UILabel *typeModelLabel;//整租合租


@end
@implementation HouseRentHouseTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
        self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
        [self.contentView addSubview:self.backGroundV];
        [self.backGroundV addSubview:self.headImgv];
        [self.backGroundV addSubview:self.titleLabel];
        [self.backGroundV addSubview:self.detailtitleLabel];
        [self.backGroundV addSubview:self.coseL];
        [self.backGroundV addSubview:self.typeBackView];//蓝色框的小label
        [self.backGroundV addSubview:self.typeModelLabel];//绿色label
        [self setUI];//typeModelLabel 隐
        [self reSetUI];//用于商铺的cell重写——滞空即可 -------- 本类的设置了 typeModelLabel 的显
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.imageView.image = nil;
    [self.typeBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
#pragma mark ==

- (void)setHouseCellmodel:(HouseRentListVcHouseCellModel *)houseCellmodel{
    _houseCellmodel = houseCellmodel;
    [self allNomailShowLabel];
    [self typeAddSubLabel];
    [self imgShow];
   
}
- (void)imgShow{
    if (_houseCellmodel.houseImage.count>0) {
        NSURL *imgUrl = [UrlWithString getURLWithStr:[NSString stringWithFormat:@"%@",_houseCellmodel.houseImage.firstObject]];
        [self.headImgv sd_setImageWithURL:imgUrl];
    }
}
- (void)allNomailShowLabel{
    self.titleLabel.text = [TextShowWithModelStr textShowWithModelStr: _houseCellmodel.houseTitle];
    NSString *detailOne = [TextShowWithModelStr textShowWithModelStr:_houseCellmodel.houseType];
    NSString *detailPingFang = [NSString stringWithFormat:@"%0.2f ㎡",_houseCellmodel.houseSquareMeter];
    NSString *detailAddress = [TextShowWithModelStr textShowWithModelStr: _houseCellmodel.houseAddress];
    self.detailtitleLabel.text = [NSString stringWithFormat:@"%@·%@·%@",detailOne,detailPingFang,detailAddress];
    self.coseL.text = [NSString stringWithFormat:@"%0.2f元/%@",_houseCellmodel.housePrice,[TextShowWithModelStr textShowWithModelStr:_houseCellmodel.houseUnit]];
}
- (void)typeAddSubLabel{
 
    NSString *strOfModel = [TextShowWithModelStr textShowWithModelStr:_houseCellmodel.houseLeaseMode];
    if (strOfModel.length==0) {
        self.typeModelLabel.text = @"不限";
    }else{
        self.typeModelLabel.text = strOfModel;
    }
//    [self setTypeBackViewSubViews:_houseCellmodel.houseAdvantage];
    [self setTypeBackViewSubViews:_houseCellmodel.houseAdvantageCode];//0416改
}

- (void)setTypeBackViewSubViews:(NSDictionary *)houseAdvantage{
    NSInteger count = 0;
    NSArray *typeKeysArr = [houseAdvantage allKeys];
    if (typeKeysArr.count==0) {
        return;//空数据 不做小标签图
    }
    if (typeKeysArr.count>3) {
        count = 3;//列表限制最多显示3个
    }else{
        count = typeKeysArr.count;
    }
    //add labe
    float  subLabY = 35;//整租合租有30w 初5间隔
    for (int i=0; i<count; i++) {
        NSString *textStr = [NSString stringWithFormat:@"%@",typeKeysArr[i]];
        //基础
        UILabel *lab = [self subBaseLab];
        //文本+fram
        lab.text = [NSString stringWithFormat:@"%@",textStr];
        CGSize labSize = [[NSString stringWithFormat:@"%@",textStr] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}]; //文本尺寸
        CGRect fram = CGRectMake(subLabY,2, labSize.width+4, 20);//+2y +4w
        lab.frame = fram;
        //下次的fram 用到的y 更新
        subLabY = subLabY + labSize.width + 5+4;//5间隔 4w
        [self.typeBackView addSubview:lab];
    }
}
- (UILabel *)subBaseLab{//基础
    UILabel *lab = [[UILabel alloc]init];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:11];
    lab.layer.cornerRadius = 2;
    lab.textColor = Y_RGBA(38, 114, 249, 1);
    lab.layer.borderColor = Y_RGBA(38, 114, 249, 1).CGColor;
    lab.layer.borderWidth = 1;
    return lab;
}
#pragma mark ==
- (void)setUI{
    [_backGroundV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backGroundV.superview).insets(UIEdgeInsetsMake(5, 16, 5, 16));
    }];
    [_headImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backGroundV.mas_centerY).offset(0);
        make.left.equalTo(_backGroundV.mas_left).offset(0);
        make.height.offset(80);
        make.width.offset(110);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImgv.mas_top).offset(0);
        make.left.equalTo(_headImgv.mas_right).offset(10);//
        make.height.offset(20);
        make.right.equalTo(_titleLabel.superview.mas_right);
    }];
    [_detailtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(0);
        make.left.equalTo(_titleLabel.mas_left).offset(0);//
        make.right.equalTo(_titleLabel.mas_right).offset(0);
        make.height.offset(15);
    }];
    [_coseL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_detailtitleLabel.mas_left).offset(0);//
        make.right.equalTo(_detailtitleLabel.mas_right).offset(0);
        make.height.offset(20);
        make.bottom.equalTo(_headImgv.mas_bottom);
    }];
    [_typeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_detailtitleLabel.mas_bottom).offset(0);
        make.left.equalTo(_detailtitleLabel.mas_left).offset(0);//
        make.right.equalTo(_detailtitleLabel.mas_right).offset(0);
        make.bottom.equalTo(_coseL.mas_top);
    }];
    [_typeModelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeBackView.mas_top).offset(2);//2
        make.left.equalTo(_typeBackView.mas_left).offset(0);
        make.width.offset(30);
        make.height.offset(20);
    }];
    self.typeModelLabel.hidden = YES;
}
- (void)reSetUI{
    self.typeModelLabel.hidden = NO;
}
#pragma mark ==
- (UIView *)backGroundV{
    if (!_backGroundV) {
        _backGroundV = [[UIView alloc]init];
        _backGroundV.backgroundColor = [UIColor clearColor];
//        _backGroundV.layer.cornerRadius = 10;
//        _backGroundV.layer.masksToBounds = YES;
    }
    return _backGroundV;
}
- (UIImageView *)headImgv{
    if (!_headImgv) {
        _headImgv = [[UIImageView alloc]init];
//        _headImgv.layer.cornerRadius = 3;
//        _headImgv.layer.masksToBounds = YES;
        [_headImgv zy_cornerRadiusAdvance:3 rectCornerType:UIRectCornerAllCorners];
//        _headImgv.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
        _headImgv.contentMode = UIViewContentModeScaleAspectFill;//
    }
    return _headImgv;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleLabel;
}
- (UILabel *)detailtitleLabel{
    if (!_detailtitleLabel) {
        _detailtitleLabel = [[UILabel alloc]init];
        _detailtitleLabel.font = [UIFont systemFontOfSize:12];
        _detailtitleLabel.textColor = Y_RGBA(197, 201, 212, 1);//[ThemeManager shareManager].mainTexDetailLightBluetColor;
        _detailtitleLabel.numberOfLines = 1;
    }
    return _detailtitleLabel;
}

- (UILabel *)coseL{
    if (!_coseL) {
        _coseL = [[UILabel alloc]init];
        _coseL.font = [UIFont boldSystemFontOfSize:15];
        _coseL.textColor = Y_RGBA(255, 0, 51, 1);// [UIColor redColor];
        _coseL.textAlignment = NSTextAlignmentLeft;
        _coseL.contentMode = UIViewContentModeBottomLeft;//
    }
    return _coseL;
}
- (UIView *)typeBackView{
    if (!_typeBackView) {
        _typeBackView = [[UIView alloc]init];
    }
    return _typeBackView;
}
- (UILabel *)typeModelLabel{
    if (!_typeModelLabel) {
        _typeModelLabel = [[UILabel alloc]init];
        _typeModelLabel.backgroundColor = Y_RGBA(0, 200, 141, 1);
        _typeModelLabel.textColor = [UIColor whiteColor];
        _typeModelLabel.font = [UIFont boldSystemFontOfSize:11];
        _typeModelLabel.layer.cornerRadius = 2;
        _typeModelLabel.layer.masksToBounds = YES;
        _typeModelLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _typeModelLabel;
}
@end

