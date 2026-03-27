//
//  SmallShopCartListViewModel.h
//  Community
//
//  Created by 余莹 on 2022/3/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SmallShopCartListViewModel : BaseDataViewModel

//个人中心 购物车数量 展示使用
+ (void)getCartListNumCountWithBlock:( void(^)(NSInteger nowCartGoosNum ,BOOL success) )block;
@end

NS_ASSUME_NONNULL_END
