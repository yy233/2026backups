//
//  LifeCostMainVcTopGroupSubAccountEntityModel.h
//  Community
//
//  Created by 余莹 on 2022/1/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostMainVcTopGroupSubAccountEntityModel : NSObject
@property (nonatomic,copy) NSString *account;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *categoryId;
@property (nonatomic,copy) NSString *cityCode;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString *company;
@property (nonatomic,copy) NSString *companyId;
@property (nonatomic,copy) NSString *groupId;
@property (nonatomic,copy) NSString *householder;
@property (nonatomic,copy) NSString *itemCode;
@property (nonatomic,copy) NSString *itemId;
@property (nonatomic,copy) NSString *provinceId;
@property (nonatomic,copy) NSString *typeId;
@property (nonatomic,copy) NSString *typeName;
@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,assign) NSInteger deleted;
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,copy) NSString *typePicUrl;
@property (nonatomic,copy) NSString *businessFlow;//    业务流程;0：先查后缴 1：直接缴费 2：二次查询;不同的业务流程,需要跳不同的页面,走不同的接口



//account = 97145061000;
//address = "";
//categoryId = 29;
//cityCode = 010;
//cityId = 103300;
//cityName = "北京市";
//company = "北京市燃气集团有限责任公司";
//companyId = 010000201;
//createTime = "2022-01-04 16:48:30";
//deleted = 0;
//groupId = 130014447463960576;
//householder = "郭丽";
//id = 141689413901094912;
//idStr = 141689413901094912;
//itemCode = 238556890;
//itemId = 254706;
//provinceId = 103300;
//typeId = 3;
//typeName = "燃气费";
//uid = 56738;
@end

NS_ASSUME_NONNULL_END
