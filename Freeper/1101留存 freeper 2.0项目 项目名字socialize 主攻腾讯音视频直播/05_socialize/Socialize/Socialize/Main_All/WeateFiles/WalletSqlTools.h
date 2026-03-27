//
//  WalletSqlTools.h
//  Socialize
//
//  Created by 余莹 on 2023/7/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^SqlDbBlock)(BOOL successs, NSMutableArray *resArr);

@interface WalletSqlTools : NSObject

singleton_interface(share);

- (void)selectThingsWithSqlArr:(NSArray *)sqlArr withBlock:(SqlDbBlock)block;
- (void)updataThingsWithSqlArr:(NSArray *)sqlArr withBlock:(SqlDbBlock)block;
- (void)dbCloseAction;
@end

NS_ASSUME_NONNULL_END
