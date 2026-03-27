//
//  IssueBuniessShopTagsModel.h
//  Community
//
//  Created by 余莹 on 2021/1/20.
// "商铺配套设施"; 商铺客流人群" 类型tags

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssueBuniessShopTagsModel : NSObject

@property (nonatomic,strong) NSString *annotation;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *houseConstName;
@property (nonatomic,assign) NSInteger deleted;
@property (nonatomic,assign) NSInteger houseConstCode;
@property (nonatomic,assign) NSInteger houseConstType;
@property (nonatomic,assign) NSInteger id;
@end
/**
 {
annotation = "商铺配套设施";
createTime = "2021-01-11 16:16:19";s
deleted = 0;
houseConstCode = 512;
houseConstName = "下水";
houseConstType = 16;
id = 129;
}
);
people =         (
 {
annotation = "商铺客流人群";
createTime = "2021-01-12 10:32:40";
deleted = 0;
houseConstCode = 1;
houseConstName = "学生人群";
houseConstType = 17;
id = 130;
},
 */
NS_ASSUME_NONNULL_END
