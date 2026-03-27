//
//  YBtnWithGesture.h
//  Community
//
//  Created by 余莹 on 2021/5/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^YBtnWithGesture_LongPressBlock)(UILongPressGestureRecognizer *);
@interface YBtnWithGesture : UIButton
@property (nonatomic,copy) YBtnWithGesture_LongPressBlock longPressBlock;
@end

NS_ASSUME_NONNULL_END
