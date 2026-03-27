//
//  SmallShppOrderModel.h
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SmallShppOrderModel : NSObject
@property (nonatomic,copy) NSString  *name;
@property (nonatomic,copy) NSString  *orderNumber;
@property (nonatomic,copy) NSString  *orderTime;
@property (nonatomic,copy) NSString  *orderAddress;
@property (nonatomic,copy) NSString  *headImg;
@property (nonatomic,assign) NSInteger orderId;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger ID;
@end

NS_ASSUME_NONNULL_END
