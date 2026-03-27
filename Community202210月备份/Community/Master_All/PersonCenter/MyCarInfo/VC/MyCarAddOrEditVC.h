//
//  MyCarAddOrEditVC.h
//  Community
//
//  Created by 余莹 on 2021/8/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCarAddOrEditVC : BaseViewController
//@property (nonatomic,assign) NSInteger nowCommunityId;//不使用社区限制
@property (nonatomic,assign) BOOL isAddCarBool;//是否为新增
@property (nonatomic,strong) NSString *idStr;
@property (nonatomic,strong) NSString *oldCarPlate;

@end

NS_ASSUME_NONNULL_END
