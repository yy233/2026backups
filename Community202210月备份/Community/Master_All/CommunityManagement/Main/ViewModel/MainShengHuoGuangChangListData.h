//
//  MainShengHuoGuangChangListData.h
//  Community
//
//  Created by 余莹 on 2021/8/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainShengHuoGuangChangListData : NSObject
+ (void)initErShouListWithBlock:(BaseListArrAndSuccessBoolBlock)block;
+ (void)updataErShouListWithPageNum:(NSInteger)pageNum withBlock:(BaseListArrAndSuccessBoolBlock)block;
@end

NS_ASSUME_NONNULL_END
