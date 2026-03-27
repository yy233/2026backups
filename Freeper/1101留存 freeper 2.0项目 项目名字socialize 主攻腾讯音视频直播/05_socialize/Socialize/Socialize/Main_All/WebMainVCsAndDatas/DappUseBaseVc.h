//
//  DappUseBaseVc.h
//  Socialize
//
//  Created by 余莹 on 2023/6/8.
//

#import <UIKit/UIKit.h>
#import "BaseWebVc.h"
NS_ASSUME_NONNULL_BEGIN

@interface DappUseBaseVc : BaseWebVc
@property (nonatomic,strong) NSDictionary *dappShowUseInfoBodyDic;
@property (nonatomic,strong) NSString *thisDappUseUrlStr;
@property (nonatomic,assign) BOOL isShouCangeType;
@end

NS_ASSUME_NONNULL_END
