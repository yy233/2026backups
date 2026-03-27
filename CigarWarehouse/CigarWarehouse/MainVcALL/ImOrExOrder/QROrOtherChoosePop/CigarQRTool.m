//
//  CigarQRTool.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/29.
//

#import "CigarQRTool.h"


 
@implementation CigarQRTool
 
+ (NSString *)rRStr_GetProductWithStr:(NSString *)str{
    NSString *productContStr = @"";
   
    if ([str containsString:QR_product] && [str containsString:QR_symbol]){
        //产品信息
        productContStr = [self anStr:str jieQuSubStringFrom:QR_symbol to:@""];
    }
    
    return productContStr;
}
+ (NSString *)rRStr_GetPosWithStr:(NSString *)str{
    NSString *posContStr = @"";
    if ([str containsString:QR_pos] && [str containsString:QR_symbol]){
        //地址信息
        posContStr =  [self anStr:str jieQuSubStringFrom:QR_symbol to:@""];////pos:123544-8888-8787
    }
    return posContStr;
}
 

+ (NSString *)anStr:(NSString *)str jieQuSubStringFrom:(NSString *)begStr to:(NSString *)endStr{
    if (str.length == 0 ||begStr.length == 0 ) {
        return @"";
    }
    //地址信息
    NSRange Range_beg = [str rangeOfString:begStr];
    NSRange Range_end;
    if (endStr.length == 0) {//默认最后尾巴位置
        Range_end = NSMakeRange(str.length-1, 1);
        NSUInteger loc = Range_beg.location + Range_beg.length;
        NSString *okStr = [str substringFromIndex:loc];
        return okStr;
    }else{
        Range_end = [str rangeOfString:endStr];
        NSUInteger loc = Range_beg.location + Range_beg.length;
        NSUInteger len = Range_end.location - Range_beg.location - Range_beg.length;
        NSRange r = NSMakeRange(loc ,len);
        NSString *okStr = [str substringWithRange:r];
        return okStr;
    }

   
}
@end
