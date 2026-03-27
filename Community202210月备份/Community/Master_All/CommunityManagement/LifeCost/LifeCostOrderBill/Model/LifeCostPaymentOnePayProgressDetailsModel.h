//
//  LifeCostPaymentOnePayProgressDetailsModel.h
//  Community
//
//  Created by 余莹 on 2021/3/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    PayProgressDetails_Status_Begin=1,
    PayProgressDetails_Status_Processing=2,
    PayProgressDetails_Status_Success=3,
} PayProgressDetails_Status;

@interface LifeCostPaymentOnePayProgressDetailsModel : NSObject
@property (nonatomic,strong) NSString *orderTime;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,strong) NSString *familyName;
@property (nonatomic,assign) NSInteger familyId;
@property (nonatomic,assign) NSInteger orderId;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) double accountBalance;//应该缴纳金额
@property (nonatomic,assign) double paymentBalance;//本次支付的金额
/**
    code = 0;
    data =     {
        accountBalance = "-56.92";
        address = "纵横世纪";
        companyName = "重庆燃气集团公司";
        familyId = 154613516;
        familyName = GG;
        orderId = 32987826903715840;
        orderTime = "2021-03-10 17:47:11";
        paymentBalance = 57;
        status = 2;
    };
    message = "<null>";
}
 */
@end

NS_ASSUME_NONNULL_END
