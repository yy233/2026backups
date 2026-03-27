//
//  HouseRentDetailBuniessShopCallAndChatTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/8.
//

#import "HouseRentDetailBuniessShopCallAndChatTableViewCell.h"
#define Color_BlueBtn    Y_RGBA(38, 114, 249, 1)
#define H_bottomCallAndOnlineCell 65
@interface HouseRentDetailBuniessShopCallAndChatTableViewCell ()
@property (nonatomic,strong) UIButton *buniessShopCallBtn;
@property (nonatomic,strong) UIView *userHeaderBackView;
@property (nonatomic,strong) UILabel *realNameL;
@property (nonatomic,strong) UILabel *yezhuLabel;
@property (nonatomic,strong) UIImageView *headerImgV;


@end
@implementation HouseRentDetailBuniessShopCallAndChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(HouseRentDetailVcHouseModel *)model{
    //重写滞空
}
- (void)setUserModel:(HouseRentDetailVcBuniessShopModelUserModel *)userModel{
    _userModel = userModel;
    [_headerImgV sd_setImageWithURL:[UrlWithString getURLWithStr:_userModel.avatarUrl]];
    _realNameL.text = [TextShowWithModelStr textShowWithModelStr:_userModel.realName];
}
    
#pragma mak ==
/**
   暂时不显示头像相关UI
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor =  [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        /**
         [self.contentView addSubview:self.userHeaderBackView];
         [self.contentView addSubview:self.buniessShopCallBtn];
         [self.userHeaderBackView addSubview:self.headerImgV];
         [self.userHeaderBackView addSubview:self.realNameL];
         [self.userHeaderBackView addSubview:self.yezhuLabel];
         [self setOtherUI];
         self.thrBtn.hidden = YES;
         self.oneBtn.hidden = YES;
        */
       
        [self.onLineBtn addTarget:self action:@selector(onLineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.oneBtn addTarget:self action:@selector(qianYueBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.thrBtn addTarget:self action:@selector(buniessShopCallBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)setOtherUI{
    [_buniessShopCallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.thrBtn);//预约看房的位置 /第三个位置
    }];
    [_userHeaderBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.oneBtn);//第一个位置
    }];
    //
    [_headerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userHeaderBackView.mas_left).offset(0);
        make.top.equalTo(_userHeaderBackView.mas_top);
        make.bottom.equalTo(_userHeaderBackView.mas_bottom);
        make.width.equalTo(_headerImgV.mas_height);
    }];
    //        _headerImgV.layer.
    [_realNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userHeaderBackView.mas_top);
        make.left.equalTo(_headerImgV.mas_right).offset(5);
        make.right.equalTo(_userHeaderBackView.mas_right);
        make.height.equalTo(_headerImgV.mas_height).multipliedBy(0.5);
    }];
    [_yezhuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_userHeaderBackView.mas_bottom);
        make.left.equalTo(_headerImgV.mas_right).offset(5);
        make.right.equalTo(_userHeaderBackView.mas_right);
        make.height.equalTo(_headerImgV.mas_height).multipliedBy(0.5);
    }];
    
      UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.headerImgV.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.headerImgV.bounds.size];
       CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
       //设置大小
       maskLayer.frame = self.headerImgV.bounds;
       //设置图形样子
       maskLayer.path = maskPath.CGPath;
}
 
#pragma mark ===
- (UIView *)userHeaderBackView{
    if (!_userHeaderBackView) {
        _userHeaderBackView = [[UIView alloc]init];
    }
    return _userHeaderBackView;
}
- (UIImageView *)headerImgV{
    if (!_headerImgV) {
        _headerImgV = [[UIImageView alloc]init];
//        _headerImgV.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2];
//        _headerImgV.layer.cornerRadius = (H_bottomCallAndOnlineCell-20)*0.5;
//        _headerImgV.layer.masksToBounds = YES;
        [_headerImgV zy_cornerRadiusAdvance:((H_bottomCallAndOnlineCell-20)*0.5) rectCornerType:UIRectCornerAllCorners];
    }
    return _headerImgV;
}
- (UILabel *)realNameL{
    if (!_realNameL) {
        _realNameL = [[UILabel alloc]init];
        _realNameL.font = [UIFont boldSystemFontOfSize:14];
        _realNameL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _realNameL;
}
- (UILabel *)yezhuLabel{
    if (!_yezhuLabel) {
        _yezhuLabel = [[UILabel alloc]init];
        _yezhuLabel.font = [UIFont systemFontOfSize:12];
        _yezhuLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _yezhuLabel.text = @"业主";
    }
    return _yezhuLabel;
    
}
- (UIButton *)buniessShopCallBtn{
    if (!_buniessShopCallBtn) {
        _buniessShopCallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buniessShopCallBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_buniessShopCallBtn setTitle:@"打电话" forState:UIControlStateNormal];
        [_buniessShopCallBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        _buniessShopCallBtn.backgroundColor = Color_BlueBtn;
        _buniessShopCallBtn.layer.cornerRadius = 5;
        _buniessShopCallBtn.layer.masksToBounds = YES;
        [_buniessShopCallBtn addTarget:self action:@selector(buniessShopCallBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buniessShopCallBtn;
}
#pragma mark== 电话
- (void)buniessShopCallBtnAction:(UIButton *)sender{
    if ([TextShowWithModelStr textShowWithModelStr:_userModel.mobile].length>0 && [TextShowWithModelStr textShowWithModelStr:_userModel.mobile].length<=11) {
        [self callPhoneWithStr:[TextShowWithModelStr textShowWithModelStr:_userModel.mobile]];
    }
}
- (void)callPhoneWithStr:(NSString *)phoneStr{
 
    NSMutableString *callStr=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneStr];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr] options:@{} completionHandler:nil];

    /**
     NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneStr];
     UIWebView * callWebview = [[UIWebView alloc] init];
     [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
     [self.view addSubview:callWebview];
     */
}
#pragma mark ==
- (void)onLineBtnAction:(UIButton *)sender{
//    NSLog(@"在线");
    if (_buniessDelegate && [_buniessDelegate respondsToSelector:@selector(buniessShopRentOfOnLineChat)]) {
        [_buniessDelegate buniessShopRentOfOnLineChat];
    }
}

- (void)qianYueBtnAction:(UIButton *)sender{
    //签约
    if (_buniessDelegate && [_buniessDelegate respondsToSelector:@selector(buniessShopRentOfQianYue)]) {
        [_buniessDelegate buniessShopRentOfQianYue];
    }
}
@end
