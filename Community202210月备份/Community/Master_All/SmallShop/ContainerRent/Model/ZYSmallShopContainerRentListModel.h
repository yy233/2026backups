//
//  ZYSmallShopContainerRentListModel.h
//  Community
//
//  Created by ZY on 2022/3/10.
//

#import <Foundation/Foundation.h>

@class ZYSmallShopContainerRentListRecordsModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYSmallShopContainerRentListModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) NSInteger pages;

@property (nonatomic, assign) NSInteger pageNo;

@property (nonatomic, strong) NSArray<ZYSmallShopContainerRentListRecordsModel *> *records;

@end


@interface ZYSmallShopContainerRentListRecordsModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *volume;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *cabinetNumber;

@property (nonatomic, copy) NSString *cabinetImg;

@property (nonatomic, copy) NSString *price;

@end

NS_ASSUME_NONNULL_END
