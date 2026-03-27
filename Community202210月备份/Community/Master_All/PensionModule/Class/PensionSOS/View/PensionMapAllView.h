//
//  PensionMapView.h
//  Community
//
//  Created by 余莹 on 2021/12/1.
//

#import <UIKit/UIKit.h>
#import "PensionMapAllViewSubChooseOneAddressMapV.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^TouchBtoomBtnActionBlock)(NSArray *);

@interface PensionMapAllView : UIView
@property (nonatomic,strong) UIView *topBackView;
@property (nonatomic,strong) UISearchBar *searchBar;
//
@property (nonatomic,strong) UIView *centerMapBackView;
@property (nonatomic,strong) PensionMapAllViewSubChooseOneAddressMapV *mapViewWithChooseAddress;//用来选择位置 返回位置信息的 map
//
@property (nonatomic,strong) UIView *bottomBackView;
@property (nonatomic,strong) UIImageView *addressShowInfoImg;
@property (nonatomic,strong) UILabel *addressShowInfoLabel;
@property (nonatomic,strong) UIButton *addressOkBtn;


- (void)initShowAddressWithLat:(double)lati withLong:(double)longi withShowAddressStr:(NSString *)willNowPostionShareManagerAddressStr; 

@property (nonatomic,copy) TouchBtoomBtnActionBlock touchBtoomBtnActionBlock;
@end

NS_ASSUME_NONNULL_END
