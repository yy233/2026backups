//
//  CarPaltWebViewVC.h
//  Community
//
//  Created by 余莹 on 2022/1/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CarPlatOkBlock)(NSString *carPlatStr);

@interface CarPaltWebViewVC : BaseViewController
@property (nonatomic,copy) CarPlatOkBlock carPlatBlock;
@end

NS_ASSUME_NONNULL_END
