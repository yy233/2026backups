//
//  IssueHouseOkSendInfoViewModel.h
//  Community
//
//  Created by 余莹 on 2021/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssueHouseOkSendInfoViewModel : NSObject
//———————————— 添加新增 post
//整租
+ (void)issueHouseSendZhengZuWithParam:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
//合租
+ (void)issueHouseSendHeZuWithParam:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
//单间
+ (void)issueHouseSendDanJianWithParam:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;

//———————————— 修改 put
//整租
+ (void)issueHouseSendZhengZuChangeWithParam:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;

//单间
+ (void)issueHouseSendDanJianChangeWithParam:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
//合租
+ (void)issueHouseSendHeZuWithChangeParam:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
 
@end

NS_ASSUME_NONNULL_END
