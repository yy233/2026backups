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
 
@end
