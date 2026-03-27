//
//  ChatServiceGetDataDecModel.h
//  Community
//
//  Created by 余莹 on 2021/4/20.
// 给服务器发imid接口返回的data 用ras解析后的数据modle

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatServiceGetDataDecModel : NSObject
//动态的 每次新的要存 后期aes使用此
@property (nonatomic,strong) NSString *aesIv;
@property (nonatomic,strong) NSString *serverAesKey;
//
@property (nonatomic,strong) NSString *userToken;
@property (nonatomic,strong) NSString *userUuid;

//0902增
@property (nonatomic,strong) NSString *token;//用于通信请求里的header的token
@end

NS_ASSUME_NONNULL_END
