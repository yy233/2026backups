//
//  CigarQRTool.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define QR_product   @"product"
#define QR_pos       @"pos"
#define QR_symbol    @":"

@interface CigarQRTool : NSObject

+ (NSString *)rRStr_GetProductWithStr:(NSString *)str;
+ (NSString *)rRStr_GetPosWithStr:(NSString *)str;


@end

NS_ASSUME_NONNULL_END
