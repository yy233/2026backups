//
//  IssueBuniessShopTypeModel.h
//  Community
//
//  Created by 余莹 on 2021/1/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    BuniessShopOrHousePublish_Type_type,     //商铺类型
    BuniessShopOrHousePublish_Type_business, //商铺行业
    BuniessShopOrHousePublish_Type_BedroomType, //卧室类型
} BuniessShopOrHousePublish_Type;

@interface IssueBuniessShopPublishTypeModel : NSObject
@property (nonatomic,strong) NSString *constName;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *typeName;
@property (nonatomic,assign) NSInteger typeId;
@property (nonatomic,assign) NSInteger deleted;
@property (nonatomic,assign) NSInteger id;
@end

NS_ASSUME_NONNULL_END
