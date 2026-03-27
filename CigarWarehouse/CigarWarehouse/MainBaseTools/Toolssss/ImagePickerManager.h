//
//  ImagePickerManager.h
//  Community
//
//  Created by 余莹 on 2021/9/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
 
typedef void(^FinishSelectImageBlcok)(UIImage *image);

@interface ImagePickerManager : NSObject

+ (ImagePickerManager *)shareManager;


- (void)selectUserpicSourceWithViewController:(UIViewController *)viewController FinishSelectImageBlcok:(FinishSelectImageBlcok)finishSelectImageBlock;

@end

NS_ASSUME_NONNULL_END
