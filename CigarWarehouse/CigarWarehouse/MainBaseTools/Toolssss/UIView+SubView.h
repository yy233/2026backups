//
//  UIView+SubView.h
//  MorningCall
//
//  Created by pc on 2020/10/26.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SubView)
- (UIView*)subViewOfClassName:(NSString*)className;
@end

NS_ASSUME_NONNULL_END
