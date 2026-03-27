//
//  ChatGroupToMeModel.h
//  Community
//
//  Created by 余莹 on 2021/5/13.
// 用户在某群的信息，群身份权限 设置的背景等信息

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatGroupInfoToMeModel : NSObject
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,strong) NSString *groupUuid;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *identity;//身份权限 1群主 2管理员 3群成员
@property (nonatomic,strong) NSString *personalBackground;
@property (nonatomic,strong) NSString *remarks;
@property (nonatomic,strong) NSString *userJoinTime;
@property (nonatomic,strong) NSString *userUuid;
/**
 avatar = "2021-05-12/6a6227a374da413aa2c41750d63d8acb.png";
 groupUuid = 1956e38ccdb741b08780579e098d4a69;
 id = 92344;
 
 identity = 1;--------身份权限 1群主 2管理员 3群成员
 
 personalBackground = "2021-05-13/70d28b6179d94d2ba1e5475fda661ef1.png";
 remarks = "\U54c8\U54c877";
 userJoinTime = "2021-05-13T17:17:37";
 userUuid = e5778bdaa9b747d5b6bb1d39c90a9ba7;
}*/

@end

NS_ASSUME_NONNULL_END
