//
//  Chatmd5WillModel.h
//  Community
//
//  Created by 余莹 on 2021/4/20.
//  给服务器发imid 做md5签名的键值

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatMd5WillModel : NSObject
@property (nonatomic,strong) NSString *data;
@property (nonatomic,strong) NSString *device_mark;
@property (nonatomic,strong) NSString *open_id;
@property (nonatomic,strong) NSString *secretKey;
@property (nonatomic,strong) NSString *time;
@end

NS_ASSUME_NONNULL_END
