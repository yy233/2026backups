//
//  ZYAddMedicalCustomBottomView.h
//  Community
//
//  Created by ZY on 2021/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYAddMedicalCustomBottomViewDelegate <NSObject>

- (void)saveButtonEvent;

@end

@interface ZYAddMedicalCustomBottomView : UIView

@property (nonatomic, weak) id<ZYAddMedicalCustomBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
