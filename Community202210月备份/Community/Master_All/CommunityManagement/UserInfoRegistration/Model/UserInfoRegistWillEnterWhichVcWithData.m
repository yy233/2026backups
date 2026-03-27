//
//  UserInfoRegistWillEnterWhichVcWithData.m
//  Community
//
//  Created by 余莹 on 2021/2/24.
//

#import "UserInfoRegistWillEnterWhichVcWithData.h"
/**
 '我的房屋
 40001未实名认证
 40002房屋待认证
 第三种条件就是返回的业主信息和业主家属信息了code为0，
 */
@implementation UserInfoRegistWillEnterWhichVcWithData
+ (void)goToWhichVcWithType:(UserInfoRegistGoToVcDataBlock)typeDataBlock{
    NSString *url = @"proprietor/user/info";
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        UserInfoRegistGoToVcDataBlock goToVcBlock = typeDataBlock;
        NSInteger code = [[[responsObject allKeys] containsObject:@"code"]?[responsObject objectForKey:@"code"]:@"1000" integerValue];//Y_ResponsObject_codeStr
        switch (code) {
            case 40001:
            {
                goToVcBlock(UserInfoRegistVC_GoToVC_Type_PersonInfoUnRegistered,YES);// 40001未实名认证
            }
                break;
            case 40002:
            {
                goToVcBlock(UserInfoRegistVC_GoToVC_Type_HouseUnRegistered,YES);// 40002房屋待认证
            }
                break;
            case 0:
            {
                goToVcBlock(UserInfoRegistVC_GoToVC_Type_Registered,YES);//跳转到 普通列表
            }
                break;
            default:
            {
                goToVcBlock(0,NO);
            }
                break;
        }
    }];
}
@end
