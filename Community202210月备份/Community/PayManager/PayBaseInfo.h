//
//  PayBaseInfo.h
//  Community
//
//  Created by 余莹 on 2022/4/6.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

static NSInteger kPayBaseInfo_TypeIndex_BaseIndex = 1110;

typedef enum : NSUInteger {
    PayBaseInfo_TypeIndex_ZFB    = 1110,
    PayBaseInfo_TypeIndex_WeChat = 1111,
    PayBaseInfo_TypeIndex_Other  = 1112,
} PayBaseInfo_TypeIndex;

@interface PayBaseInfo : NSObject

singleton_interface(share);

@property (nonatomic,strong) NSMutableArray *payTypeStrArr;
@property (nonatomic,strong) NSMutableArray *payTypeStrIndexArr;

@property (nonatomic,strong) NSMutableArray *payTypeStrArr_HidenWX;
@property (nonatomic,strong) NSMutableArray *payTypeStrIndexArr_HidentWeChat;


@end

NS_ASSUME_NONNULL_END
