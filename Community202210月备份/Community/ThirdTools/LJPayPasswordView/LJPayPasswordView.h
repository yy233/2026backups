//
//  LJPayPasswordView.h
//  Community
//
//  Created by 刘久炼 on 2021/2/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LJPayPasswordView;

@protocol LJPayPasswordViewDelegate <NSObject>

@optional
/** 监听输入的变化 */
- (void)passwordDidChange:(LJPayPasswordView *)password;

/** 监听开始输入 */
- (void)passwordBeginInput:(LJPayPasswordView *)password;

/** 监听输入完成时 */
- (void)passwordCompleteInput:(LJPayPasswordView *)password;

@end

@interface LJPayPasswordView : UIView

@property (assign, nonatomic) IBInspectable NSUInteger passwordNumber;///<密码的位数;

@property (assign, nonatomic) IBInspectable CGFloat squareSize;///<正方形大小;

@property (assign, nonatomic) IBInspectable CGFloat pointRadius;///<黑点半径;

@property (strong, nonatomic) IBInspectable UIColor * pointColor;///<黑点的颜色;

@property (strong, nonatomic) IBInspectable UIColor * rectColor;///<边框的颜色;

@property (strong, nonatomic) NSMutableString * saveStore;///<保存密码的字符串;

@property (weak, nonatomic) id<LJPayPasswordViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
