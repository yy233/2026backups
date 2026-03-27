//
//  ZYCityModel.h
//  Community
//
//  Created by ZY on 2022/1/5.
//

#import <Foundation/Foundation.h>

@class ZYCityListModel, ZYCityListDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYCityModel : NSObject <YYModel>

@property (nonatomic, strong) NSArray<ZYCityListModel *> *cityCategoryModelList;

@property (nonatomic, strong) NSArray<ZYCityListModel *> *cityHotCategoryModelList;

@end


@interface ZYCityListModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *section;

@property (nonatomic, strong) NSArray<ZYCityListDataModel *> *cityModelList;

@end


@interface ZYCityListDataModel : NSObject

@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, copy) NSString *provinceId;

@property (nonatomic, copy) NSString *cityCode;

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, copy) NSString *categoryType;

@property (nonatomic, copy) NSString *cityFlag;

@end

NS_ASSUME_NONNULL_END
