//
//  ConnectUrl.h
//  Community
//
//  Created by 余莹 on 2020/12/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConnectUrl : NSObject
+(NSString *) connectUrl:(NSMutableDictionary *)params url:(NSString *) urlLink;
@end

NS_ASSUME_NONNULL_END
