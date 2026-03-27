//
//  TopInformationModel.h
//  Community
//
//  Created by 余莹 on 2020/12/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopInformationModel : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *avatarUrl;
@property (nonatomic,strong) NSString *unreadInformCreateTime;
@property (nonatomic,strong) NSString *unreadInformTitle;
@property (nonatomic,assign) NSInteger unread;
@property (nonatomic,assign) NSInteger id;
/**
 "id": 2,
             "name": "联想社区",
             "avatarUrl": "https://dss0.bdstatic.com/6Ox1bjeh1BF3odCf/it/u=1341119447,3269779640&fm=85&app=81&f=JPEG?w=121&h=75&s=1FF6C9169DE0DE010B54D2F402005035",
             "unread": 6,
             "unreadInformCreateTime": "2020-11-18 09:41:04",
             "unreadInformTitle": "美国总统第三顺位继任者感染新冠"
 */
@end

NS_ASSUME_NONNULL_END
