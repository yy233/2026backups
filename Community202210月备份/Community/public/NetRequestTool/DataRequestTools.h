//
//  DataRequestTools.h
//  Community
//
//  Created by 余莹 on 2020/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataRequestTools : NSObject
+ (void)codeRequestWithParmeters:(NSDictionary *)parameters succ:(requestSuccess)succ fail:(requestFailure)fail;

@end

NS_ASSUME_NONNULL_END
