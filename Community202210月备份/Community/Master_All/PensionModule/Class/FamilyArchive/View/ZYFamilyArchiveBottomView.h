//
//  ZYFamilyArchiveBottomView.h
//  Community
//
//  Created by ZY on 2021/11/18.
//

#import <UIKit/UIKit.h>

@protocol ZYFamilyArchiveBottomViewDelegate <NSObject>

- (void)medicalCustomButtonEvent;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZYFamilyArchiveBottomView : UIView

@property (nonatomic, weak) id<ZYFamilyArchiveBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
