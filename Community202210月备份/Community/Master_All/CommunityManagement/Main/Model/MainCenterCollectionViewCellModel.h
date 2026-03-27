//
//  MainCenterCollectionViewCellModel.h
//  Community
//
//  Created by 余莹 on 2020/11/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainCenterCollectionViewCellModel : NSObject

@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,assign)NSInteger deleted;
@property (nonatomic,strong)NSString *descr;
@property (nonatomic,strong)NSString *icon;//不用这个 功能cell 图片有黑白两个模式
@property (nonatomic,assign)NSInteger id;
@property (nonatomic,strong)NSString *menuName;
@property (nonatomic,assign)NSInteger parentId;
@property (nonatomic,strong)NSString *path;
@property (nonatomic,assign)NSInteger sort;
@property (nonatomic,strong)NSString *updateTime;
//图片
@property (nonatomic,strong)NSString *dayIcon;
@property (nonatomic,strong)NSString *nightIcon;
/**
 菜单
*/
/**
 data =     (
             {
         communityId = 1;
         createTime = "2020-11-14 17:17:10";
         dayIcon = "白天图片.png";
         deleted = 0;
         descr = "这是我的房屋";
         id = 2;
         menuName = "我的房屋";
         nightIcon = "夜晚图片.png";
         parentId = 1;
         path = "/community/home";
         status = 0;
         updateTime = "2020-11-14 17:17:13";
     },
             {
         communityId = 1;
         createTime = "2020-11-14 17:17:10";
         dayIcon = "白天图片.png";
         deleted = 0;
         descr = "这是生活缴费";
         id = 3;
         menuName = "生活缴费";
         nightIcon = "夜晚图片.png";
         parentId = 1;
         path = "/community/cost";  
         status = 0;
         updateTime = "2020-11-14 17:17:10";
     },
             {
         communityId = 1;
         createTime = "2020-11-15 21:00:07";
         dayIcon = "白天图片.png";
         deleted = 0;
         descr = "这是访客邀请";
         id = 6;
         menuName = "访客邀请";
         nightIcon = "夜晚图片.png";
         parentId = 1;
         path = "/community/visitor";
         status = 0;
         updateTime = "2020-11-16 10:07:55";
     }
 );
 message = "<null>";
 */
@end

NS_ASSUME_NONNULL_END
