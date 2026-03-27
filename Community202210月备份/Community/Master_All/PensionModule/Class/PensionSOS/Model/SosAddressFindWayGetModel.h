//
//  SosAddressFindWayGetModel.h
//  Community
//
//  Created by 余莹 on 2021/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SosAddressFindWayGetModel : NSObject
@property (nonatomic,assign) NSInteger deleted;
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *lat;
@property (nonatomic,copy) NSString *lon;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *updateTime;
@property (nonatomic,copy) NSString *createTime;
/***
 address = "<null>";
 createTime = "2021-11-30 15:40:59";
 deleted = 0;
 id = 128988851237687296;
 lat = "153.465165";
 lon = "156.165465";
 uid = 55262;
 updateTime = "2021-11-30 15:40:59";
 */
@end

NS_ASSUME_NONNULL_END
