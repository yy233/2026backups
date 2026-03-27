//
//  UIImage+ImageRoundedCorner.h
//  Community
//
//  Created by 余莹 on 2022/1/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ImageRoundedCorner)

- (UIImage*)imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
