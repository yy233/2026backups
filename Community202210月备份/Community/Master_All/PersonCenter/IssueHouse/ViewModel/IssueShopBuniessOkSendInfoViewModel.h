//
//  IssueShopBuniessOkSendInfoViewModel.h
//  Community
//
//  Created by 余莹 on 2021/3/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssueShopBuniessOkSendInfoViewModel : NSObject
//商铺
//-------- 新增数据post
+ (void)issueShopBuniessOkSendInfoWithParam:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
//-------- 更新数据post
+ (void)issueShopBuniessOkSendInfoChangeWithParam:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
@end

NS_ASSUME_NONNULL_END
