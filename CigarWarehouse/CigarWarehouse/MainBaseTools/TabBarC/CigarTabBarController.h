//
//  CigarTabBarController.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TabBarSubVc_Num_ShowHomePage,
    TabBarSubVc_Num_ManagerPage,
    TabBarSubVc_Num_PersonPage,
} TabBarSubVc_Num;


@interface CigarTabBarController : UITabBarController
@property (nonatomic,assign) NSInteger oldSelectIndex;//记录当前点击到的index

@end

NS_ASSUME_NONNULL_END
