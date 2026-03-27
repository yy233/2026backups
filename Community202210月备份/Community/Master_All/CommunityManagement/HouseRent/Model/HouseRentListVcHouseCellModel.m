//
//  HouseRentListVcModel.m
//  Community
//
//  Created by 余莹 on 2020/12/30.
//

#import "HouseRentListVcHouseCellModel.h"

@implementation HouseRentListVcHouseCellModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

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
    CGFloat oneCellW = (Screen_W-32-22-10)/2;
    CGFloat textTopTitleUseW = ( oneCellW - 50 -10 -5);
    CGFloat textAddressUseW =  ( oneCellW - 20);
    heightTitle =  [Tool getTextHeightWhenHaveWidthFloatNum:textTopTitleUseW withTextStr:self.houseTitle withFont:[UIFont boldSystemFontOfSize:14]];
    heightTitle = ( heightTitle>25) ?  heightTitle : 25;
    heightAddress  =  [Tool getTextHeightWhenHaveWidthFloatNum:textAddressUseW withTextStr:self.houseAddress withFont:[UIFont boldSystemFontOfSize:11]];
    //
    heightTitle = (heightTitle > 25) ? heightTitle : 25;
    heightAddress = (heightAddress > 25) ? heightAddress : 25;
    
    if (self.houseAdvantageCode.count>0) {
            heightTips = 40;
    }else{
        heightTips = 5;//当作间隔高度
    }
    
    heightALL = heightTitle + heightAddress + heightTips + heightImg + heightMoney;
    return heightALL;
}
@end
