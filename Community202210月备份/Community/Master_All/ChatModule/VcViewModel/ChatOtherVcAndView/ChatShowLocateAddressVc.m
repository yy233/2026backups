//
//  ChatShowLocateAddressVc.m
//  Community
//
//  Created by 余莹 on 2021/10/22.
//

#import "ChatShowLocateAddressVc.h"
#import "ChatBaseMapView.h"
#import "SystemMapNavigatioManger.h"
#import "AllMapNavigatioManger.h"

@interface ChatShowLocateAddressVc ()

@property (nonatomic,strong) UIView  *topV;
@property (nonatomic,strong) UIView  *centerV;
@property (nonatomic,strong) ChatBaseMapView *mapV;
@property (nonatomic,strong) UIView  *bottomV;
@property (nonatomic,strong) UILabel *showTextL;
@property (nonatomic,strong) UIButton *gotoBtn;
@end

@implementation ChatShowLocateAddressVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.showTextL.text = self.showAddressStr;
}
- (void)initView{
    [self.view addSubview:self.centerV];
    [self.view addSubview:self.bottomV];
    [self.centerV addSubview:self.mapV];
    [self.bottomV addSubview:self.showTextL];
    [self.bottomV addSubview:self.gotoBtn];
    [self setUI];
}
- (void)setUI{
    _centerV.backgroundColor = Color_245Gray;
    _bottomV.backgroundColor = [UIColor whiteColor];
    [_centerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_centerV.superview);
        make.bottom.equalTo(_centerV.superview).offset(-kGHSafeAreaBottomHeight-100);
    }];
    [_mapV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mapV.superview);
    }];
    //
    [_bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerV.mas_bottom);
        make.left.bottom.right.equalTo(_bottomV.superview);
    }];
    [_showTextL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_showTextL.superview).insets(UIEdgeInsetsMake(10, 16, 10, 100));
    }];
    [_gotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_showTextL);
        make.left.equalTo(_showTextL.mas_right);
        make.right.equalTo(_showTextL.superview.mas_right).offset(-16);
        make.height.offset(30);
    }];
   
}
- (UIView *)centerV{
    if (!_centerV) {
        _centerV = [[UIView alloc]init];
    }
    return _centerV;
}
- (UIView *)bottomV{
    if (!_bottomV) {
        _bottomV = [[UIView alloc]init];
    }
    return _bottomV;
}
- (ChatBaseMapView *)mapV{
    if (!_mapV) {
        _mapV = [[ChatBaseMapView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-kNavBarHeight-kGHSafeAreaBottomHeight-100)];
    }
    return _mapV;
}
- (UILabel *)showTextL{
    if (!_showTextL) {
        _showTextL = [[UILabel alloc]init];
        _showTextL.numberOfLines = 0;
        _showTextL.textColor = Color_51BlackColor;
        _showTextL.font = [UIFont systemFontOfSize:15];
    }
    return _showTextL;
}
 
- (UIButton *)gotoBtn{
    if (!_gotoBtn) {
        _gotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gotoBtn newAnBtnWithTextStr:@"导航到这"];
        [_gotoBtn newAnBtnWithFont:[UIFont systemFontOfSize:14]];
        [_gotoBtn newAnBtnWithTextColor:Y_ColorWith16FromRGB(0x3699FF)];
        [_gotoBtn newAnBtnWithLayerCorNerNum:10 withLayerLineWidth:1.0 withLayerLineColor:Y_ColorWith16FromRGB(0x3699FF)];
        [_gotoBtn addTarget:self action:@selector(gotoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gotoBtn;
}
- (void)gotoBtnAction{
//    [SystemMapNavigatioManger goToSystemMapNavigatioWithLat:self.lati lon:self.longi title:[TextShowWithModelStr textShowWithModelStr:self.showAddressStr]];
    [AllMapNavigatioManger  gotoAddressWithLat:self.lati lon:self.longi title:self.showAddressStr  andPresntVC:self];

}
@end
