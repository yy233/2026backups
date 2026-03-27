//
//  UserCertificationChooseHouseDetailAddressVC.h
//  Community
// 选择地址的list (@"城市",@"小区",@"楼栋",@"单元",@"门牌" 总列表) （跳转涉及到 ChooseUserCityAndOther文件夹内vc）
//  Created by 余莹 on 2020/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
 
//新
typedef enum : NSUInteger {
    queryType_Num_willGetCommunityNextList  = 2, //求小区的下一级用2
    queryType_Num_willGetBuildNextList      = 3, //求小区的下一级 build 的下一级用3
    queryType_Num_willGetUnityNextList      = 3, //求小区的下一级 unit  的下一级用3
    queryType_Num_willGetBuildNextFloorList      = 3, //求(小区-build) 的下一级用3 得floor_list
    queryType_Num_willGetBuildNextUnityNextFloorList      = 3, //求(小区-build-unity) 的下一级用3 得floor_list
    queryType_Num_willGetAddressList        = 3, //求 门牌
}queryType_Num ;


@interface UserCertificationChooseHouseDetailAddressVC : BaseViewController
@property (nonatomic,strong) NSDictionary *saveChooseEndUserInfoModelUseLateVcAddHouse;
@end

NS_ASSUME_NONNULL_END
