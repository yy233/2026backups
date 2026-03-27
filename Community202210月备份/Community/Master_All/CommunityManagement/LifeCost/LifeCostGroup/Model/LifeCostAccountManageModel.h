//
//  LifeCostAccountManageModel.h
//  Community
//
//  Created by 余莹 on 2021/3/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostAccountManageModel : NSObject

@property (nonatomic,assign) NSInteger companyId;
@property (nonatomic,assign) NSInteger familyId;
@property (nonatomic,assign) NSInteger typeId;
@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,strong) NSString *groupName;
@property (nonatomic,strong) NSString *typeName;


/**
 data =     {
     map =         {
         "我家" =             (
                             {
                 companyId = 1;
                 companyName = "水费";
                 c = 1056134646;
                 groupName = "我家";
                 typeId = 1;
                 typeName = "重庆江南水务公司";
             },
                             {
                 companyId = 3;
                 companyName = "燃气费";
                 familyId = 154613516;
                 groupName = "我家";
                 typeId = 13;
                 typeName = "重庆燃气集团公司";
             }
 
         )
 "房东" =             (
 );
 "朋友" =             (
                     {
         companyId = 2;
         companyName = "电费";
         familyId = 105613516;
         groupName = "朋友";
         typeId ;*/
@end

NS_ASSUME_NONNULL_END
