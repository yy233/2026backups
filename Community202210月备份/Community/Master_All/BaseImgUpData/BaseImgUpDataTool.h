//
//  BaseImgUpDataTool.h
//  Community
//
//  Created by 余莹 on 2022/4/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseImgUpDataTool : NSObject
+ (void)baseUpImgWithOneImg:(UIImage *)phototImg withParms:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block;//公共接口
@end

NS_ASSUME_NONNULL_END
