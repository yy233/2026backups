//
//  BaseImgTool.m
//  Socialize
//
//  Created by 余莹 on 2023/8/25.
//

#import "BaseImgTool.h"

@implementation BaseImgTool

+ (UIImage *)placeholdHeadImg{
    
    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type #define  kTheme_Type_Key   @"Theme_Type"
    UIImage *pImg;
    if([nowThemeStr isEqualToString: @"light"]){
        pImg = [UIImage imageNamed:@"default_c2c_head_0821W"];

    }else{
        pImg = [UIImage imageNamed:@"default_c2c_head_0821D"];

    }
    return pImg;
}
@end
