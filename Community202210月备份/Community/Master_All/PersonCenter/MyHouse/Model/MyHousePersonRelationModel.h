//
//  MyHousePersonRelationModel.h
//  Community
//
//  Created by 余莹 on 2021/8/18.
//

#import <Foundation/Foundation.h>
#import "MyHousePersonRelationSubMemberModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    PersonRelatio_Num_YeZhu  = 1,//业主
    PersonRelatio_Num_JiaShu = 6,//家属
    PersonRelatio_Num_Zuke   = 7,//租客
} PersonRelatio_Num; 


@interface MyHousePersonRelationModel : NSObject
@property (nonatomic,strong) NSString *avatarUrl;
@property (nonatomic,assign) NSInteger houseId;
@property (nonatomic,strong) NSString *houseSite;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *relationText;
@property (nonatomic,assign) NSInteger relation;//1为业主
@property (nonatomic,strong) NSArray *members;
@property (nonatomic,strong) NSString *idCard;//身份证
 



/**
 1/proprietor/user/house/details____{
    code = 0;
    data =     {
        houseId = 90854402528776192;
        houseSite = "D栋1单元5103";
        members =         (
                        {
                id = 91304220183105536;
                mobile = 15023576859;
                name = "张无忌";
                relation = 6;
                relationText = "亲属";
            },
                        {
                id = 91304220183105537;
                mobile = 15736185885;
                name = "金毛狮王";
                relation = 7;
                relationText = "租户";
            }
        );
        name = "余莹";
        relation = 1;
        relationText = "业主";
    };
    message = "<null>";*/
@end

NS_ASSUME_NONNULL_END
