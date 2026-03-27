//
//  UITextField+PlaceholderNewColor.h
//  Community
//
//  Created by 余莹 on 2020/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (PlaceholderNewColor)
- (void)attributedPlaceholderWithStr:(NSString *)placeholderStr newColor:(UIColor *)color;
- (void)loginModuleAttributedPlaceholderNewColorWithStr:(NSString *)placeholderStr;
- (void)mainModuleAttributedPlaceholderNewColorWithStr:(NSString *)placeholderStr;
@end

NS_ASSUME_NONNULL_END
