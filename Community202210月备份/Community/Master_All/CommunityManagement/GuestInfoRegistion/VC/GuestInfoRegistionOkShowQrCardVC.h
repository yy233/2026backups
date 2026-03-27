//
//  GuestInfoRegistionOkShowQrCardVC.h
//  Community
//
//  Created by 余莹 on 2021/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GuestInfoRegistionOkShowQrCardVC : BaseHaveTableViewViewController

//header
@property (nonatomic,strong) UILabel *tipLabel;
//
@property (nonatomic,strong) UIView *qrBackView;
@property (nonatomic,strong) UIImageView *qrBackImgV;//4:6的比例
//
@property (nonatomic,strong) UIView *subTopBackView_4Proportion;
@property (nonatomic,strong) UIView *subBottomBackView_6Proportion;




//top
@property (nonatomic,strong) UILabel *guestNameShowLabel;//名字带星号
@property (nonatomic,strong) UILabel *addressShowLabel;
@property (nonatomic,strong) UIButton *showPasswordTipBtn;//开门密码
@property (nonatomic,strong) UIButton *showPasswordStrBtn;//（暂无｜蓝色文本）（预留复制功能使用btn类型）
//bottom
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) UILabel *timeDelineShowLabel;
@property (nonatomic,strong) UIImageView *qrInfoImgV;

//___
@property (nonatomic,assign) BOOL isNowSuccessToShow;//成功后立即查看的yes 列表详情走来查看的NO
@property (nonatomic,strong) NSString *visitorId;//二维码所需ID
@property (nonatomic,strong) NSString *showPasswordStr;//1028 手动输入的密码类型数据

@property (nonatomic,strong) NSString *houseNameShowStr;
@property (nonatomic,strong) NSString *timeDelineShowStr;
@property (nonatomic,strong) NSString *personNameShowStr;
//

@end

NS_ASSUME_NONNULL_END
