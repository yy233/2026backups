//
//  ThemeImg.m
//  Community
//
//  Created by 余莹 on 2020/11/28.
//

#import "ThemeImg.h"

@implementation ThemeImg
+ (UIImage *)themeImageWithBaseName:(NSString *)imgNameStr{
    if ([ThemeManager shareManager].type == ThemeType_White) {
        NSString *whietImgName = [NSString stringWithFormat:@"%@",imgNameStr];
        return [UIImage imageNamed:whietImgName];
    }
    if ([ThemeManager shareManager].type == ThemeType_Drak) {
        NSString *drakImgName = [NSString stringWithFormat:@"%@",imgNameStr];
        return [UIImage imageNamed:drakImgName];
    }
    return [[UIImage alloc]init];
}
+ (UIImage *)loginModuleThemeImageWithBaseName:(NSString *)imgNameStr{
    if ([ThemeManager shareManager].type == ThemeType_White) {
        NSString *whietImgName = [NSString stringWithFormat:@"%@",imgNameStr];
        return [UIImage imageNamed:whietImgName];
    }
    if ([ThemeManager shareManager].type == ThemeType_Drak) {
        NSString *drakImgName = [NSString stringWithFormat:@"%@",imgNameStr];
        return [UIImage imageNamed:drakImgName];
    }
    return [[UIImage alloc]init];
    
}

+ (UIImage *)mainModulethemeImageWithBaseName:(NSString *)imgNameStr{
    if ([ThemeManager shareManager].type == ThemeType_White) {
        NSString *whietImgName = [NSString stringWithFormat:@"%@",imgNameStr];
        return [UIImage imageNamed:whietImgName];
    }
    if ([ThemeManager shareManager].type == ThemeType_Drak) {
        NSString *drakImgName = [NSString stringWithFormat:@"%@",imgNameStr];
        return [UIImage imageNamed:drakImgName];
    }
    return [[UIImage alloc]init];
}
@end
