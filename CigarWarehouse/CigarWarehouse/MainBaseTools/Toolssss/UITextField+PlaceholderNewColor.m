//
//  UITextField+PlaceholderNewColor.m
//  Community
//
//  Created by 余莹 on 2020/11/30.
//

#import "UITextField+PlaceholderNewColor.h"

@implementation UITextField (PlaceholderNewColor)
 
- (void)attributedPlaceholderWithStr:(NSString *)placeholderStr newColor:(UIColor *)color{
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholderStr attributes:@{NSForegroundColorAttributeName:color}];
    self.attributedPlaceholder = placeholderString;
}
- (void)loginModuleAttributedPlaceholderNewColorWithStr:(NSString *)placeholderStr {
//    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholderStr attributes:@{NSForegroundColorAttributeName:[ThemeManager shareManager].loginModuleDetailTextColorIsAlphaFifty}];
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholderStr attributes:@{NSForegroundColorAttributeName:[[UIColor whiteColor] colorWithAlphaComponent:0.8]}];
    self.attributedPlaceholder = placeholderString;
}

- (void)mainModuleAttributedPlaceholderNewColorWithStr:(NSString *)placeholderStr {
 /**
  
  if ([ThemeManager shareManager].type == ThemeType_Drak) {
      NSDictionary *attributsDic = @{NSForegroundColorAttributeName:Y_RGBA(195, 216, 255, 1),NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
      NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholderStr attributes:attributsDic];
      self.attributedPlaceholder = placeholderString;
  }else{
      NSDictionary *attributsDic = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
//        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholderStr attributes:@{NSForegroundColorAttributeName:attributsDic}];// 'NSInvalidArgumentException', reason: '-[__NSDictionaryI CGColor]: 崩溃留档待删
      NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholderStr attributes:attributsDic];
      self.attributedPlaceholder = placeholderString;
  }
  */
    
    NSDictionary *attributsDic = @{NSForegroundColorAttributeName:Y_RGBA(195, 216, 255, 1),NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholderStr attributes:attributsDic];
    self.attributedPlaceholder = placeholderString;
    
}
@end
