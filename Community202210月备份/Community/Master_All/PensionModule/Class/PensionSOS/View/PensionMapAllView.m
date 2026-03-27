//
//  PensionMapView.m
//  Community
//
//  Created by 余莹 on 2021/12/1.
//

#import "PensionMapAllView.h"

@interface PensionMapAllView () <UISearchBarDelegate>

@end

@implementation PensionMapAllView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.topBackView];
        [self.topBackView addSubview:self.searchBar];
        [self addSubview:self.centerMapBackView];
        [self.centerMapBackView addSubview:self.mapViewWithChooseAddress];
        [self addSubview:self.bottomBackView];
        [self.bottomBackView addSubview:self.addressShowInfoImg];
        [self.bottomBackView addSubview:self.addressShowInfoLabel];
        [self.bottomBackView addSubview:self.addressOkBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
 
    [self topUI];
    [self bottomUI];
    [self centerUI];
}
- (void)topUI{
    [_topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topBackView.superview);
        make.height.offset(75);
    }];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_searchBar.superview);
    }];
   
}
- (void)centerUI{
    [_centerMapBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_centerMapBackView.superview);
        make.top.equalTo(_topBackView.mas_bottom);
        make.bottom.equalTo(_bottomBackView.mas_top);
    }];
    [_mapViewWithChooseAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mapViewWithChooseAddress.superview);
    }];
    //地图移动
    WEAKSELF
    _mapViewWithChooseAddress.mapMoveChangedBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.addressShowInfoLabel.text = weakSelf.mapViewWithChooseAddress.saveShooseAddressTextStr;
        });
    };
 
}
- (void)bottomUI{
    [_bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomBackView.superview);
        make.height.offset(56+KIndicatorHeight);
    }];
    [_addressOkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_addressOkBtn.superview).offset(-16);
        make.width.offset(45);
        make.height.offset(35);
        make.centerY.equalTo(_addressOkBtn.superview);
    }];

    [_addressShowInfoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(17);
        make.centerY.equalTo(_addressShowInfoImg.superview);
        make.left.equalTo(_addressShowInfoImg.superview).offset(16);
    }];
    [_addressShowInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_addressShowInfoLabel.superview);
        make.left.equalTo(_addressShowInfoImg.mas_right).offset(5);
        make.right.equalTo(_addressOkBtn.mas_left).offset(-10);
    }];
    
}
#pragma mark ==

- (PensionMapAllViewSubChooseOneAddressMapV *)mapViewWithChooseAddress{
    if (!_mapViewWithChooseAddress) {
        _mapViewWithChooseAddress = [[PensionMapAllViewSubChooseOneAddressMapV alloc]init];
    }
    return _mapViewWithChooseAddress;
}

#pragma mark ==
- (UIView *)topBackView{
    if (!_topBackView) {
        _topBackView = [[UIView alloc]init];
        _topBackView.backgroundColor = Y_ColorWith16FromRGB(0xFFFFFF);
    }
    return _topBackView;
}

- (UIView *)bottomBackView{
    if (!_bottomBackView) {
        _bottomBackView = [[UIView alloc]init];
        _bottomBackView.backgroundColor = Y_ColorWith16FromRGB(0xF0F1F6);//C5C9D4);
    }
    return _bottomBackView;
}
- (UIView *)centerMapBackView{
    if (!_centerMapBackView) {
        _centerMapBackView = [[UIView alloc]init];
    }
    return _centerMapBackView;
}
//
- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.searchTextField.font = [PensionThemeManager shareManager].Pension_TextFont_15;
        _searchBar.backgroundColor = Y_ColorWith16FromRGB(0xF0F1F6);
        _searchBar.layer.cornerRadius = 5;
        _searchBar.placeholder = @"可给找路功能 设置路线终点位置";
        _searchBar.searchBarStyle = UISearchBarStyleDefault;
        _searchBar.delegate = self;
    }
    return _searchBar;
}
//
- (UIButton *)addressOkBtn{
    if (!_addressOkBtn) {
        _addressOkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressOkBtn newAnBtnWithFont:[PensionThemeManager shareManager].Pension_TextFont_13];
        [_addressOkBtn newAnBtnWithTextStr:@"确定"];
        [_addressOkBtn newAnBtnWithBackColor:Y_ColorWith16FromRGB(0x36C8C1)];
        [_addressOkBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_addressOkBtn newAnBtnWithLayerCorNerNum:5.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_addressOkBtn addTarget:self action:@selector(addressChooseOkAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressOkBtn;
}
- (UILabel *)addressShowInfoLabel{
    if (!_addressShowInfoLabel) {
        _addressShowInfoLabel = [[UILabel alloc]init];
        _addressShowInfoLabel.textColor = Color_51BlackColor;
        _addressShowInfoLabel.font = [PensionThemeManager shareManager].Pension_TextFont_13;
        _addressShowInfoLabel.numberOfLines = 0;
    }
    return _addressShowInfoLabel;
}
- (UIImageView *)addressShowInfoImg{
    if (!_addressShowInfoImg) {
        _addressShowInfoImg = [[UIImageView alloc]init];
        _addressShowInfoImg.image = [UIImage imageNamed:@"yl_adress02"];
    }
    return _addressShowInfoImg;
}

#pragma mark == UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self findWithSearchTextStr:searchBar.text];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
     [self findWithSearchTextStr:searchBar.text];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    [self findWithSearchTextStr:searchBar.text];
    [self endEditing:YES];
}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{

    [self findWithSearchTextStr:searchBar.text];
    [self endEditing:YES];
}
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{

    [self findWithSearchTextStr:searchBar.text];
    [self endEditing:YES];
}
 
- (void)findWithSearchTextStr:(NSString *)searchTextStr{

    NSLog(@"searchTextStr = %@",searchTextStr);
    if (searchTextStr.length<=0) {
        return;
    }else{
        [self.mapViewWithChooseAddress searchAddressWithSearchText:searchTextStr];//按文本搜索附近 
    }
}
 //
- (void)initShowAddressWithLat:(double)lati withLong:(double)longi withShowAddressStr:(NSString *)willNowPostionShareManagerAddressStr{
    self.addressShowInfoLabel.text = willNowPostionShareManagerAddressStr;
    [self.mapViewWithChooseAddress setlocateToLatitude:lati longitude:longi];
  
}
//
- (void)addressChooseOkAction{
    if (isNotNil(self.touchBtoomBtnActionBlock)) {
        WEAKSELF
        NSArray *chooseAddressInfoArr = [NSArray arrayWithObjects:
                                         weakSelf.mapViewWithChooseAddress.saveShooseAddressLatStr,
                                         weakSelf.mapViewWithChooseAddress.saveShooseAddressLongStr,
                                         weakSelf.mapViewWithChooseAddress.saveShooseAddressTextStr, nil];
        self.touchBtoomBtnActionBlock(chooseAddressInfoArr);
    }

    
    
}
@end
