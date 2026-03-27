//
//  MainShengHuoGuangChangListErShouUseModel.m
//  Community
//
//  Created by 余莹 on 2021/8/24.
//

#import "MainShengHuoGuangChangListErShouUseModel.h"

@implementation MainShengHuoGuangChangListErShouUseModel
- (CGFloat)getHeightUseMainVcShow{
    CGFloat heightALL = 0;
    //
    CGFloat heightImg = 140;
    CGFloat heightMoney = 30;
    //
    CGFloat heightTitle = 25;
    CGFloat heightAddress = 25;
    CGFloat heightTips = 5;
    
    //
//    CGFloat oneCellW = (Screen_W-32-22-10)/2;//窄cell
    CGFloat oneCellW = (Screen_W-32-2-10)/2;//宽cell +左右20占满
    CGFloat textTopTitleUseW = ( oneCellW - 50 -10 -5);
    CGFloat textAddressUseW =  ( oneCellW - 20);
    heightTitle =  [Tool getTextHeightWhenHaveWidthFloatNum:textTopTitleUseW withTextStr:self.goodsName withFont:[UIFont boldSystemFontOfSize:14]];
    heightTitle = ( heightTitle>25) ?  heightTitle : 25;
    heightAddress  =  [Tool getTextHeightWhenHaveWidthFloatNum:textAddressUseW withTextStr:self.categoryName withFont:[UIFont boldSystemFontOfSize:11]];
    //
    heightTitle = (heightTitle > 25) ? heightTitle : 25;
    heightAddress = (heightAddress > 25) ? heightAddress : 25;

//    if (self.goodsExplain > 0) {
//            heightTips = 40;
//    }else{
//        heightTips = 5;//当作间隔高度
//    }
    heightTips = 5;//当作间隔高度
    heightALL = heightTitle + heightAddress + heightTips + heightImg + heightMoney;
    return heightALL;
}
@end
