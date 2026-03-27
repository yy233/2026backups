//
//  ZYMedicalCustomBottomView.h
//  Community
//
//  Created by ZY on 2021/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYMedicalCustomBottomViewDelegate <NSObject>

- (void)addButtonEvent;

@end

@interface ZYMedicalCustomBottomView : UIView

@property (nonatomic, weak) id<ZYMedicalCustomBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
