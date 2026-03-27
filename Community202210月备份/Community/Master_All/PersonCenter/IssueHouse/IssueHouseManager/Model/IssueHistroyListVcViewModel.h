//
//  IssueHistroyListVcViewModel.h
//  Community
//
//  Created by 余莹 on 2021/2/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssueHistroyListVcViewModel : NSObject

+ (void)issueHistroyListWithHouseWithParm:(NSMutableDictionary *)parm withListBloclk:(BaseListArrAndSuccessBoolBlock)listBlock;
+ (void)issueHistroyListWithBuniessShopWithParm:(NSMutableDictionary *)parm withListBloclk:(BaseListArrAndSuccessBoolBlock)listBlock;
@end

NS_ASSUME_NONNULL_END
