//
//  ComplanintsSuggesstionsModel.h
//  Community
//
//  Created by 余莹 on 2021/3/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComplanintsSuggesstionsModel : NSObject

+ (void)sendCompanintsImgWithImg:(UIImage *)img withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
+ (void)sendAllCompanintParmsWithParms:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)dicBlock;

@end

NS_ASSUME_NONNULL_END
