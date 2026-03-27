//
//  PayBaseInfo.m
//  Community
//
//  Created by 余莹 on 2022/4/6.
//

#import "PayBaseInfo.h"

@implementation PayBaseInfo
singleton_implementation(share);

- (NSMutableArray *)payTypeStrArr{
    if (!_payTypeStrArr) {
        if ( kPayMoneyTypeShow_HidenZFB == 1 ) {
            _payTypeStrArr = [[NSMutableArray alloc]initWithObjects:@"微信",nil];
        }else{
            _payTypeStrArr = [[NSMutableArray alloc]initWithObjects:@"支付宝",@"微信",nil];
        }
    
    }
    return _payTypeStrArr;
}
- (NSMutableArray *)payTypeStrIndexArr{
    if (!_payTypeStrIndexArr) {
        if ( kPayMoneyTypeShow_HidenZFB == 1 ) {
            _payTypeStrIndexArr = [[NSMutableArray alloc]initWithObjects:@(PayBaseInfo_TypeIndex_WeChat), nil];

        }else{
            _payTypeStrIndexArr = [[NSMutableArray alloc]initWithObjects:@(PayBaseInfo_TypeIndex_ZFB),@(PayBaseInfo_TypeIndex_WeChat), nil];

        }
    }
    return _payTypeStrIndexArr;
}

//______________

- (NSMutableArray *)payTypeStrArr_HidenWX{
    if (!_payTypeStrArr_HidenWX) {
        if ( kPayMoneyTypeShow_HidenZFB == 1 ) {
            _payTypeStrArr_HidenWX = [[NSMutableArray alloc]initWithCapacity:0];
        }else{
            _payTypeStrArr_HidenWX = [[NSMutableArray alloc]initWithObjects:@"支付宝",nil];

        }
    }
    return _payTypeStrArr_HidenWX;
}
- (NSMutableArray *)payTypeStrIndexArr_HidentWeChat{
    if (!_payTypeStrIndexArr_HidentWeChat) {
        if ( kPayMoneyTypeShow_HidenZFB == 1 ) {
            _payTypeStrIndexArr_HidentWeChat = [[NSMutableArray alloc]initWithCapacity:0];

        }else{
            _payTypeStrIndexArr_HidentWeChat = [[NSMutableArray alloc]initWithObjects:@(PayBaseInfo_TypeIndex_ZFB), nil];

        }
    }
    return _payTypeStrIndexArr_HidentWeChat;
}
@end
