//
//  MainAllTypeInformationVC.h
//  Community
//
//  Created by 余莹 on 2021/8/30.
//个人中心 推送总消息列表

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    InfomationVc_Type_commnitMain, //主页
    InfomationVc_Type_smallShopMain,//仓储小店主页
} InfomationVc_Type;


@interface MainAllTypeInformationVC : BaseTableViewController
@property (nonatomic,assign) InfomationVc_Type infomationVc_type;

@end

NS_ASSUME_NONNULL_END
