//
//  SmallShopMyBoxModel.h
//  Community
//
//  Created by 余莹 on 2022/3/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SmallShopMyBoxModel : NSObject
@property (nonatomic,copy) NSString  *title;
@property (nonatomic,copy) NSString * cabinetId;
@property (nonatomic,copy) NSString  *cabinetImg;
@property (nonatomic,copy) NSString  *cabinetNumber;
@property (nonatomic,assign) NSInteger  cabinetSize;
@property (nonatomic,assign) NSInteger  residueDay;
@property (nonatomic,assign) NSInteger  communityId;

 

/**
 oolOfNetWork.m:275      YrequestPostURLNoMainQueueWithBodyNotParms Reply JSON: {
     code = 0;
     data =     {
         countId = "<null>";
         current = 1;
         hitCount = 0;
         maxLimit = "<null>";
         optimizeCountSql = 1;
         orders =         (
         );
         pages = 1;
         records =         (
                         {
                 cabinetId = 1498593337188675585;
                 cabinetImg = "https://img008.hc360.cn/k1/M07/43/7B/wKhQw1j4YoOEYENBAAAAANEaVro830.jpg";
                 cabinetNumber = 1234562;
                 cabinetSize = 20;
                 communityId = 144598606245138432;
                 residueDay = 18;
                 storeId = 1498534868334215170;
                 title = "标题";
             },
                         {
                 cabinetId = 1498593340971937793;
                 cabinetImg = "https://img008.hc360.cn/k1/M07/43/7B/wKhQw1j4YoOEYENBAAAAANEaVro830.jpg";
                 cabinetNumber = 1234563;
                 cabinetSize = 20;
                 communityId = 144598606245138432;
                 residueDay = 18;
                 storeId = 1498534868334215170;
                 title = "标题";
             },
                         {
                 cabinetId = 1498593343069089794;
                 cabinetImg = "https://img008.hc360.cn/k1/M07/43/7B/wKhQw1j4YoOEYENBAAAAANEaVro830.jpg";
                 cabinetNumber = 1234564;
                 cabinetSize = 20;
                 communityId = 144598606245138432;
                 residueDay = 18;
                 storeId = 1498534868334215170;
                 title = "标题";
             }
         );
         searchCount = 1;
         size = 10;
         total = 3;
     };
     message = "操作成功";
 */
@end

NS_ASSUME_NONNULL_END
