//
//  CommunityFunListModel.h
//  Community
//
//  Created by 余莹 on 2020/12/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ListBlock)(BOOL,NSArray *,NSInteger);//数据 成功与否，本次总条数
@interface CommunityFunListViewModel : NSObject
+ (void)comunityFunListInitWithListBlock:(ListBlock)listBlock;
+ (void)comunityFunListInitWithSearchStr:(NSString *)searchStr WithListBlock:(ListBlock)listBlock;
+ (void)comunityFunListWithPageNum:(NSInteger)pageNum UpdateWithListBlock:(ListBlock)listBlock;
+ (void)comunityFunListWithPageNum:(NSInteger)pageNum UpdateWithSearchStr:(NSString *)searchStr WithListBlock:(ListBlock)listBlock;
 
@end

NS_ASSUME_NONNULL_END
