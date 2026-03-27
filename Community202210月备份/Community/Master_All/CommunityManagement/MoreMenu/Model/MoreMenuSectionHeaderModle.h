//
//  MoreMenuSectionHeaderModle.h
//  Community
//
//  Created by 余莹 on 2020/12/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoreMenuSectionHeaderModle : NSObject
@property (nonatomic,strong) NSString *menuName;
@property (nonatomic,assign) NSInteger parentId;
@property (nonatomic,strong) NSMutableArray <MainCenterCollectionViewCellModel *>*childMenus;
/**
 childMenus =             (
                     {
         dayIcon = "白天图片.png";
         id = 2;
         menuName = "我的房屋";
         nightIcon = "夜晚图片.png";
         parentId = 1;
         path = "/community/home";
     },
                     {
         dayIcon = "白天图片.png";
         id = 3;
         menuName = "生活缴费";
         nightIcon = "夜晚图片.png";
         parentId = 1;
         path = "/community/cost";
     },
                     {
         dayIcon = "白天图片.png";
         id = 6;
         menuName = "访客邀请";
         nightIcon = "夜晚图片.png";
         parentId = 1;
         path = "/community/visitor";
     },
                     {
         dayIcon = "白天图片.png";
         id = 7;
         menuName = "-------------------------扫一扫";scan 一键报修"; repair 服务热线";hotline "投诉建议"; advice
         nightIcon = "夜晚图片.png";
         parentId = 1;
         path = "/community/scan";
     },
                     {
         dayIcon = "白天图片.png";
         id = 34;
         menuName = "一键报修";
         nightIcon = "夜晚图片.png";
         parentId = 1;
         path = "/community/repair";
     },
                     {
         dayIcon = "白天图片.png";
         id = 35;
         menuName = "服务热线";
         nightIcon = "夜晚图片.png";
         parentId = 1;
         path = "/community/hotline";
     },
                     {
         dayIcon = "白天图片.png";
         id = 36;
         menuName = "投诉建议";
         nightIcon = "夜晚图片.png";
         parentId = 1;
         path = "/community/advice";
     }
 );
 id = 1;
 menuName = "社区服务";
 parentId = 0;
 */
@end

NS_ASSUME_NONNULL_END
