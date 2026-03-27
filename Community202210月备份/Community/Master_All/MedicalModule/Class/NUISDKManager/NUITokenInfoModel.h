//
//  NUIManager.h
//  Community
//
//  Created by 余莹 on 2021/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NUITokenInfoModel : NSObject

singleton_interface(share);
@property (nonatomic,strong) NSString *token;
@property (nonatomic,assign) NSInteger expireTime;
@end

NS_ASSUME_NONNULL_END
