//
//  PersonMoneyModelData.h
//  Community
//
//  Created by 余莹 on 2021/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonMoneyModelData : NSObject


+ (void)getPersonMoneyDataWithBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
@end

//
@interface PersonMoneyModel : NSObject

@property (nonatomic,assign) double balance;//钱
@property (nonatomic,assign) NSInteger tickets;//券数量
@property (nonatomic,assign) NSInteger bankCard;//银行卡数量

@end

NS_ASSUME_NONNULL_END
