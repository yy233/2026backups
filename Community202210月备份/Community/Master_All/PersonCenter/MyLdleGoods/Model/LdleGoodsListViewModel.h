//
//  LdleGoodsListViewModel.h
//  Community
//
//  Created by 余莹 on 2022/6/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//1上架  0下架
typedef enum : NSUInteger {
    LdleGoods_Type_Down = 0,
    LdleGoods_Type_Up  = 1,
} LdleGoods_Type;

@interface LdleGoodsListViewModel : BaseDataViewModel
@property (nonatomic,assign) LdleGoods_Type typeState;
@end

NS_ASSUME_NONNULL_END
