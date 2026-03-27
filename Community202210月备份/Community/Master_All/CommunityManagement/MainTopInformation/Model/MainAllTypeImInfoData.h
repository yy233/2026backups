//
//  MainAllTypeImInfoData.h
//  Community
//
//  Created by 余莹 on 2021/9/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainAllTypeImInfoData : NSObject
// 总类型列表消息数据
+ (void)initImMessageListWithArrBlcok:(BaseListArrAndSuccessBoolBlock)block;
+ (void)upDataImMessageListWithPageNum:(NSInteger)pageNum withArrBlcok:(BaseListArrAndSuccessBoolBlock)block;
//
// 分类型列表消息数据 用toUser对方聊天号获取
+ (void)initImMessageListWithToUser:(NSString *)toUser withArrBlcok:(BaseListArrAndSuccessBoolBlock)block;
+ (void)upDataImMessageListWithToUser:(NSString *)toUser withPageNum:(NSInteger)pageNum withArrBlcok:(BaseListArrAndSuccessBoolBlock)block;

//清空
+ (void)deleImMessageWithParms:(NSMutableDictionary *)bodyDic withBlock:(BaseDicAndSuccessBoolBlock)block;
@end

NS_ASSUME_NONNULL_END
