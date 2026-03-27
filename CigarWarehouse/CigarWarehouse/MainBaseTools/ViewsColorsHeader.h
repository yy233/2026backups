//
//  ViewsColorsHeader.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/18.
//

#ifndef ViewsColorsHeader_h
#define ViewsColorsHeader_h
 
#pragma mark ========================================= 主题色

// 颜色
#define C_ColorWith16FromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define C_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define C_RGB(r,g,b)    C_RGBA(r,g,b,1.0f)
#define C_rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define C_Gradient_Color(width,height,_BeginColor,_EndColor) [UIColor bm_colorGradientChangeWithSize:CGSizeMake(width, height) direction:IHGradientChangeDirectionLevel startColor:_BeginColor endColor:_EndColor]
 

#define CC_Bule_A       C_RGB(49,93,241)
#define CC_Bule_B       C_RGB(97,144,243)
#define CC_Bule_C       C_RGB(167,193,245)
#define CC_Bule_D       C_RGB(213,226,249)

#define CC_Red_A       C_RGB(230,77,96)
#define CC_Red_B       C_RGB(233,122,102)
#define CC_Red_C       C_RGB(239,172,130)
#define CC_Red_D       C_RGB(253,244,215)

#define CC_Red_Drak_A       C_RGB(107,36,33)
#define CC_Red_Drak_B       C_RGB(85,20,15)


#define CC_Green_A       C_RGB(89,167,139)
#define CC_Green_B       C_RGB(133,205,168)
#define CC_Green_C       C_RGB(181,240,199)
#define CC_Green_D       C_RGB(223,249,234)

#define CC_Brown_A       C_RGB(81,57,55)
#define CC_Brown_B       C_RGB(140,113,89)
#define CC_Brown_C       C_RGB(215,202,189)
#define CC_Brown_D       C_RGB(241,227,209)


#define CC_GrayAndBlue     C_RGB(187,202,229)
#define CC_GrayAndRed      C_RGB(201,157,183)
#define CC_GrayAndOrange   C_RGB(221,209,174)

#define CC_TwoColorGradient_DrakGray_Light C_RGB(26,26,26)
#define CC_TwoColorGradient_DrakGray_Drak  C_RGB(103,119,114)

#define  CC_img_placeholder_branner         [UIImage imageNamed:@"cc_placeholder_banner"]

#endif /* ViewsColorsHeader_h */
