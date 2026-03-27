//
//  ZYLeadFamilyArchiveBottomView.h
//  Community
//
//  Created by ZY on 2021/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYLeadFamilyArchiveBottomViewDelegate <NSObject>

- (void)okButtonEvent;

@end

@interface ZYLeadFamilyArchiveBottomView : UIView

@property (nonatomic, weak) id<ZYLeadFamilyArchiveBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
