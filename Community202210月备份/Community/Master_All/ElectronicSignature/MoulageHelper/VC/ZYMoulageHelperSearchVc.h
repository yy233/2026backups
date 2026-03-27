//
//  ZYMoulageHelperSearchVc.h
//  Community
//
//  Created by ZY on 2021/7/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYMoulageHelperSearchVc : ZYBaseViewController

@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) BOOL isSystemTemplate;

// 是否草稿箱
@property (nonatomic, assign) BOOL isDraft;

@property (nonatomic, strong) ZYRentSignInfoModel *rentSignInfoModel;

@end

NS_ASSUME_NONNULL_END
