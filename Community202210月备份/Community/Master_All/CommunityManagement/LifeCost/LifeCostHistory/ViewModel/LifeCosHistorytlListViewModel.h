//
//  LifeCosHistorytlListViewModel.h
//  Community
//
//  Created by 余莹 on 2021/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCosHistorytlListViewModel : NSObject
+ (void)getHistoryListWithParms:(NSMutableDictionary *)parms withlistBlock:(BaseDicAndSuccessBoolBlock)listBlock;
@end

NS_ASSUME_NONNULL_END
