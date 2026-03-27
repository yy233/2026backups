//
//  UIView+SubView.m
//  MorningCall
//
//  Created by pc on 2020/10/26.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "UIView+SubView.h"

@implementation UIView (SubView)
- (UIView*)subViewOfClassName:(NSString*)className {
    for (UIView* subView in self.subviews) {
        if ([NSStringFromClass(subView.class) isEqualToString:className]) {
            return subView;
        }

        UIView* resultFound = [subView subViewOfClassName:className];
        if (resultFound) {
            return resultFound;
        }
    }
    return nil;
}
@end
