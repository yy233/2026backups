//
//  MedicalWebViewVc.h
//  Community
//
//  Created by 余莹 on 2021/12/7.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MedicalWebViewVc_ShowInitType_BaseShoppingMain,   //总商城base+post
    MedicalWebViewVc_ShowInitType_MedicalServices,//医疗服务
    MedicalWebViewVc_ShowInitType_MallGoods,      //推荐产品
    MedicalWebViewVc_ShowInitType_StoreDetail,    //商品详情
    MedicalWebViewVc_ShowInitType_ServicesDetail, //服务详情
    MedicalWebViewVc_ShowInitType_FillInTheDiseaseExpertInformation,//填写病症
    MedicalWebViewVc_ShowInitType_MyOrder         //我的订单
} MedicalWebViewVc_ShowInitType;
 
NS_ASSUME_NONNULL_BEGIN

@interface MedicalWebViewVc : UIViewController
@property (nonatomic,assign) MedicalWebViewVc_ShowInitType selfInitType;
//店铺详情所需数据
@property (nonatomic,strong) NSString *shopNameStr;
@property (nonatomic,strong) NSString *shopIdStr;
//服务详情所需数据
@property (nonatomic,assign) NSInteger serviceType; 
@property (nonatomic,strong) NSString *serviceIdStr;
 
@end

NS_ASSUME_NONNULL_END
