//
//  LifeCostAddNewCompanyModel.h
//  Community
//
//  Created by 余莹 on 2021/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostAddNewCompanyModel : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,assign) NSInteger deleted;
@property (nonatomic,assign) NSInteger companyId;
@property (nonatomic,assign) NSInteger regionId;
@property (nonatomic,assign) NSInteger typeId;
 
/**
 {
 companyId = 12;
 name = "重庆朝天门供水有限公司";
 regionId = 500000;
 typeId = 1;
*/
@end

NS_ASSUME_NONNULL_END
