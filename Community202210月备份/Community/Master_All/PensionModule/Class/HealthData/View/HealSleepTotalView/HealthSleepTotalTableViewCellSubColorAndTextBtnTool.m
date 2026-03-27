//
//  HealthSleepTotalTableViewCellSubColorAndTextBtn.m
//  Community
//
//  Created by 余莹 on 2021/11/18.
//

#import "HealthSleepTotalTableViewCellSubColorAndTextBtnTool.h"
#define BtnNomal_Max_W     ((Screen_W - 32-20)/2)           //BtnNomal_Max_W 最大值
#define BtnRightImg_WH (10)
@implementation HealthSleepTotalTableViewCellSubColorAndTextBtnTool

+ (UIButton *)buttonWithType:(UIButtonType)buttonType withCreatBtnRightImgColor:(UIColor *)color withShowBtnTextStr:(NSString *)textStr{
    UIButton *btn = [UIButton buttonWithType:buttonType];
    [btn newAnBtnWithFont:[PensionThemeManager shareManager].Pension_TextFont_11];
    [btn newAnBtnWithTextColor:Color_51BlackColor];
    [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    //text
    if (textStr.length>0) {
        [btn newAnBtnWithTextStr:textStr];
    }else{
        [btn newAnBtnWithTextStr:@""];
    }
    //img
    if (isNotNil(color)) {
         UIImage *btnImg = [ImgSetSize setimageSize:[UIImage imageWithColor:color] width:BtnRightImg_WH height:BtnRightImg_WH];
        [btn newAnBtnWithImg:btnImg];
    }
    return btn;
   
}
 

@end
