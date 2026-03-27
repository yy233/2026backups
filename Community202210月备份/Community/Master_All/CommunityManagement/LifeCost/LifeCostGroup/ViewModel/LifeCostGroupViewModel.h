//
//  LifeCostGroupViewModel.h
//  Community
//
//  Created by 余莹 on 2021/3/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostGroupViewModel : NSObject
/**
 户号管理
 */
+ (void)getHuHaoManageWithGroupList:(BaseDicAndSuccessBoolBlock)dicBlock;
/**
 新增自定义分组
 */
+ (void)addGroupWithParms:(NSMutableDictionary *)parms withblock:(BaseDicAndSuccessBoolBlock)dicBlock;
@end

NS_ASSUME_NONNULL_END
