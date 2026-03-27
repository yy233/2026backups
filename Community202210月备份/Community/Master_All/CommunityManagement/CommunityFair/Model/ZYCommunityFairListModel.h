//
//  ZYCommunityFairListModel.h
//  Community
//
//  Created by ZY on 2021/8/26.
//

#import <Foundation/Foundation.h>

@class ZYCommunityFairListDataModel, ZYCommunityFairListDataListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYCommunityFairListModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) ZYCommunityFairListDataModel *data;

@end


@interface ZYCommunityFairListDataModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSArray<ZYCommunityFairListDataListModel *> *list;

@end


@interface ZYCommunityFairListDataListModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, assign) NSInteger click;

@property (nonatomic, copy) NSString *goodsExplain;

@property (nonatomic, assign) NSInteger negotiable;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *labelId;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, copy) NSString *labelName;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy) NSString *images;

@end

NS_ASSUME_NONNULL_END
