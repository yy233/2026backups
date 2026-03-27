//
//  LifeCostMainVcTopGroupSectionModel.h
//  Community
//
//  Created by 余莹 on 2022/1/5.
//

#import <Foundation/Foundation.h>
#import "LifeCostMainVcTopGroupSubAccountEntityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LifeCostMainVcTopGroupSectionModel : NSObject
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *updateTime;
@property (nonatomic,copy) NSString *groupName;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,assign) NSInteger deleted;
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,copy) NSArray *accountEntityList;


/**
 data =     (
             {
         accountEntityList =             (
                             {
                 account = 97145061000;
                 address = "";
                 categoryId = 29;
                 cityCode = 010;
                 cityId = 103300;
                 cityName = "北京市";
                 company = "北京市燃气集团有限责任公司";
                 companyId = 010000201;
                 createTime = "2022-01-04 16:48:30";
                 deleted = 0;
                 groupId = 130014447463960576;
                 householder = "郭丽";
                 id = 141689413901094912;
                 idStr = 141689413901094912;
                 itemCode = 238556890;
                 itemId = 254706;
                 provinceId = 103300;
                 typeId = 3;
                 typeName = "燃气费";
                 uid = 56738;
             }
         );
         createTime = "2021-12-03 11:36:21";
         deleted = 0;
         groupName = "新家";
         id = 130014447463960576;
         idStr = 130014447463960576;
         uid = 56738;
         updateTime = "2021-12-03 14:29:15";
     }
 );
 message = "<null>";*/
@end

NS_ASSUME_NONNULL_END
