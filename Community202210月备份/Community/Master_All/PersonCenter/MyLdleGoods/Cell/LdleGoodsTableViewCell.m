//
//  LdleGoodsTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/6/11.
//

#import "LdleGoodsTableViewCell.h"
#import "BezierPathTool.h"
@implementation LdleGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark =====
- (void)fillLdleGoodsInfoWithModel:(LdleGoodsModel *)model{
    //时间
//    self.imgV.image = Main_PlaceholderImg_WeqH;
//    self.titleL.text = @"goodsInfogoodsInfogoodsInfogoodsInfogoodsInfo999";
//    self.moneyL.text = [NSString  stringWithFormat:@"¥%0.2f",68.89];
//    [self.goodsStuasBtn newAnBtnWithTextStr:@"明显使用痕迹"];
//    CGFloat goodsStuasBtn_H = [Tool getTextWidthWhenOneLineWithTextStr:@"明显使用痕迹" withFont:[UIFont systemFontOfSize:14.0]];
//    if (goodsStuasBtn_H > 0) {//有状态数据
//        [_goodsStuasBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.offset(goodsStuasBtn_H+10);
//        }];
//    }
    
    NSString *imgUrl = [[TextShowWithModelStr textShowWithModelStr:model.imagesUrl] componentsSeparatedByString:@","].firstObject;
    [self.imgV sd_setImageWithURL:[UrlWithString getURLWithStr:imgUrl] placeholderImage:Main_PlaceholderImg_WeqH];
    self.titleL.text = [TextShowWithModelStr textShowWithModelStr:model.goodsName];
    self.moneyL.text = [NSString  stringWithFormat:@"¥%0.2f",model.price];
    [self.goodsStuasBtn newAnBtnWithTextStr: [TextShowWithModelStr textShowWithModelStr:model.labelName]];
    CGFloat goodsStuasBtn_H = [Tool getTextWidthWhenOneLineWithTextStr:[TextShowWithModelStr textShowWithModelStr:model.labelName] withFont:[UIFont systemFontOfSize:14.0]];
    if (goodsStuasBtn_H > 0) {//有状态数据
        [_goodsStuasBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(goodsStuasBtn_H+10);
        }];
    }
    
    
}
#pragma mark ====
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.centerMainBackView];
        [self.centerMainBackView addSubview:self.imgV];
        [self.centerMainBackView addSubview:self.titleL];
        [self.centerMainBackView addSubview:self.goodsStuasBtn];
        [self.centerMainBackView addSubview:self.moneyL];
        [self setGoodsInfoCellUI];
      
    }
    return self;
}
- (void)setGoodsInfoCellUI{
     
    [_centerMainBackView mas_makeConstraints:^(MASConstraintMaker *make) {//纵向有3个约束用来确定本Cell高度
        make.width.equalTo(_centerMainBackView.superview).offset(-32);
        make.centerX.equalTo(_centerMainBackView.superview);
        make.top.equalTo(_centerMainBackView.superview).offset(0.0);
        make.bottom.equalTo(_centerMainBackView.superview).offset(0.0);
        make.height.offset(130);
    }];
    
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV.superview).offset(20);
        make.left.equalTo(_imgV.superview).offset(12);
        make.width.height.offset(100);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV);
        make.left.equalTo(_imgV.mas_right).offset(12);
        make.right.equalTo(_titleL.superview).offset(-16);
    }];
    [_goodsStuasBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom).offset(5);
        make.left.equalTo(_titleL);
        make.height.offset(24);
        make.width.offset(0);
        
    }];
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL);
        make.height.offset(30);
        make.top.equalTo(_goodsStuasBtn.mas_bottom).offset(5);
    }];
    self.goodsStuasBtn.userInteractionEnabled = YES;
    
}
#pragma mark ===
- (UIView *)centerMainBackView{
    if (!_centerMainBackView) {
        _centerMainBackView = [[UIView alloc]init];
        _centerMainBackView.clipsToBounds = YES;
    }
    return _centerMainBackView;
}

- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV.layer.cornerRadius = 5.0;
        _imgV.layer.masksToBounds = YES;
    }
    return _imgV;
}

- (UIButton *)goodsStuasBtn{
    if (!_goodsStuasBtn) {
        _goodsStuasBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goodsStuasBtn newAnBtnWithFont: [UIFont systemFontOfSize:11]];
        [_goodsStuasBtn newAnBtnWithTextColor:Y_ColorWith16FromRGB(0xFF8319)];
        [_goodsStuasBtn newAnBtnWithLayerCorNerNum:5 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_goodsStuasBtn newAnBtnWithBackColor: [Y_ColorWith16FromRGB(0xFF8319) colorWithAlphaComponent:0.2]];
    }
    return _goodsStuasBtn;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.numberOfLines = 3;
        _titleL.font = [UIFont boldSystemFontOfSize:14.0];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleL;
}

- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.font = [UIFont boldSystemFontOfSize:14.0];
        _moneyL.textColor = Y_ColorWith16FromRGB(0xFF3A3A);
    }
    return _moneyL;
}
@end

#pragma mark === LdleGoodsOfShowRedWeiGuiViewTableViewCell

@implementation LdleGoodsOfShowRedWeiGuiViewTableViewCell
//@property (nonatomic,strong) UILabel *weiGuiRedL;//违规view
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        WEAKSELF
        [weakSelf.imgV mas_remakeConstraints:^(MASConstraintMaker *make) {//top加了10
            make.top.equalTo(weakSelf.imgV.superview).offset(30);
            make.left.equalTo(weakSelf.imgV.superview).offset(12);
            make.width.height.offset(100);
        }];
        [self.centerMainBackView addSubview:self.weiGuiRedL];
        [self setweiGuiUI];
      
    }
    return self;
}
- (void)setweiGuiUI{
    [_weiGuiRedL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_weiGuiRedL.superview);
        make.height.offset(20);
    }];
    //圆角
    
    [self weiGuiLabekOtherUI];

}
- (void)weiGuiLabekOtherUI{
    CGRect carPlateBounds =  CGRectMake(0, 0, Screen_W-16*2, 20);//60为cell_h

    CGSize carPlateCornerRadiSize = CGSizeMake(10, 10);
    //上半的圆角
    _weiGuiRedL.layer.mask = [BezierPathTool bezierPathToolWithThisViewBounds:carPlateBounds
                                                              withCornerRadi:carPlateCornerRadiSize
                                                         withRoundingCorners: (UIRectCornerTopLeft | UIRectCornerTopRight)];
}


- (UILabel *)weiGuiRedL{
    if (!_weiGuiRedL) {
        _weiGuiRedL = [[UILabel alloc]init];
        _weiGuiRedL.text = @"此商品为违规商品，已被强制下架";
        _weiGuiRedL.textColor = [UIColor whiteColor];
        _weiGuiRedL.font = [UIFont systemFontOfSize:12.0];
        _weiGuiRedL.backgroundColor = Y_ColorWith16FromRGB(0xFF3A3A);
        _weiGuiRedL.textAlignment = NSTextAlignmentCenter;
    }
    return _weiGuiRedL;
}
@end

#pragma mark === LdleGoodsBottomTwoBtnTableViewCell
 
@implementation LdleGoodsBottomTwoBtnTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.oneBtn];
        [self.contentView addSubview:self.twoBtn];//最右边的按钮
        [self setTowBtnCellUI];
      
    }
    return self;
}
- (void)setTowBtnCellUI{
    [_twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {//最右边按钮
        make.top.equalTo(_twoBtn.superview);
        make.right.equalTo(_twoBtn.superview).offset(-26);
        make.width.offset(60);
        make.height.offset(26);
        make.bottom.equalTo(_twoBtn.superview).offset(-10);
        
    }];
    [_oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {//蓝色
        make.top.bottom.height.equalTo(_twoBtn);
        make.right.equalTo(_twoBtn.mas_left).offset(-15);
        make.width.offset(60);
    }];
}
#pragma mark ===
//蓝色
- (UIButton *)oneBtn{
    if (!_oneBtn) {
        _oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oneBtn newAnBtnWithFont:[UIFont systemFontOfSize:14.0]];
        [_oneBtn newAnBtnWithLayerCorNerNum:13.0 withLayerLineWidth:0.0 withLayerLineColor:[UIColor whiteColor]];
        [_oneBtn newAnBtnWithTextColor: [UIColor whiteColor]];
        [_oneBtn newAnBtnWithBackColor: Y_ColorWith16FromRGB(0x2672F9)];
        [_oneBtn newAnBtnWithTextStr:@"编辑"];
        [_oneBtn addTarget:self action:@selector(oneBtnAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _oneBtn;
}
//最右边按钮
- (UIButton *)twoBtn{
    if (!_twoBtn) {
        _twoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_twoBtn newAnBtnWithFont:[UIFont systemFontOfSize:14.0]];
        [_twoBtn newAnBtnWithLayerCorNerNum:13.0 withLayerLineWidth:0.5 withLayerLineColor:[ThemeManager shareManager].detailTextColor];
        [_twoBtn newAnBtnWithTextColor: [ThemeManager shareManager].detailTextColor];
        [_twoBtn newAnBtnWithBackColor: [UIColor clearColor]];
        [_twoBtn newAnBtnWithTextStr:@"下架"];
        [_twoBtn addTarget:self action:@selector(twoBtnAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _twoBtn;
}
- (void)oneBtnAction{
    if (isNil(self.touchCellSubBtnBlock)) {
        return;
    }
    self.touchCellSubBtnBlock(NO);
}

- (void)twoBtnAction{
    if (isNil(self.touchCellSubBtnBlock)) {
        return;
    }
    self.touchCellSubBtnBlock(YES);
}
@end


#pragma mark === LdleGoodsBottomTwoBtnOfNeedUpDataTableViewCell
 
@implementation LdleGoodsBottomTwoBtnOfNeedUpDataTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        [self.oneBtn newAnBtnWithTextStr:@"重新上架"];
        [self.twoBtn newAnBtnWithTextStr:@"删除"];
        [self.oneBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(90);
        }];
      
    }
    return self;
}
 
@end
