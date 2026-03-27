//
//  ZYMedicalMainTopView.h
//  Community
//
//  Created by ZY on 2021/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYMedicalMainTopViewDelegate <NSObject>

- (void)showButtonEvent;

@end

@interface ZYMedicalMainTopView : UIView

@property (nonatomic, weak) id<ZYMedicalMainTopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
