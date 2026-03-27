//
//  LifeCostPayOrderActionSuccessModel.h
//  Community
//
//  Created by 余莹 on 2022/1/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostPayOrderGetWithSuccessOrFailModel : NSObject
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) NSString *orderNo;
 

@end

NS_ASSUME_NONNULL_END
