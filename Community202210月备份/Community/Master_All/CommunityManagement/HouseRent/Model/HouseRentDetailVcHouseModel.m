//
//  HouseRentDetailVcHouseShopModel.m
//  Community
//
//  Created by 余莹 on 2021/1/6.
//

#import "HouseRentDetailVcHouseModel.h"

@implementation HouseRentDetailVcHouseModel
- (CGFloat)getHouseCellTitleHeight{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18]};
    CGSize size = [self.houseTitle boundingRectWithSize:CGSizeMake(Screen_W- (16.0f * 2), MAXFLOAT)
                                               options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                            attributes:attribute
                                               context:nil].size;
    
    size.height += (10.0f);//分隔间距
    return size.height;
}
- (CGFloat)getHouseTitleCellAllHeight{
    return ([self getHouseCellTitleHeight] +30);
}

//介绍文本
- (CGFloat)getHouseIntroduceHeight{
    /**
     //1行 使用宽度
     CGSize labSize = [[NSString stringWithFormat:@"%@",self.houseIntroduce] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
     //未知字体大小 算rect
     
     NSAttributedString *attributedstr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",self.summarize]];
     CGRect rect = [attributedstr boundingRectWithSize:CGSizeMake(Screen_W- (16.0f * 2), MAXFLOAT)
     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
     context:nil];
     CGSize size = CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
     //高度在遇到分段时短了
     if ([self.houseIntroduce containsString:@"\n"]) {
       NSArray *huanhangfuArr = [self.houseIntroduce componentsSeparatedByString:@"\n"];
         size.height = size.height + 15*(huanhangfuArr.count-1);
         NSLog(@"------ %lu,%@",(unsigned long)huanhangfuArr.count,huanhangfuArr);
     }
     */
    
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize size = [self.houseIntroduce boundingRectWithSize:CGSizeMake(Screen_W- (16.0f * 2), MAXFLOAT)
                                               options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                            attributes:attribute
                                               context:nil].size;
    size.height += (10.0f * 2.0f);//分隔间距20
   
    
    return size.height;
}
//介绍的家具等list
- (CGFloat)getHouseIntroduceListViewHeight{
    //4个一行
   CGFloat yCellNum = self.houseFurniture.count/4 + (self.houseFurniture.count%4==0 ? 0 : 1);
    return yCellNum*25+20;//20间隔空隙
}
//总高度
- (CGFloat)getHouseIntroduceHeightAllHeight{
    CGFloat titletH = 20;
    CGFloat textContentH =  [self getHouseIntroduceHeight];
    CGFloat listViewHeight = [self getHouseIntroduceListViewHeight];
    CGFloat listAllH = titletH + textContentH + listViewHeight +10;//
    return  listAllH;
}

//总高度 出租要求
- (CGFloat)getLeaseRequireMapHeightAllHeight{
    //4个一行
    NSArray *leaseRequireMapArr = [self.leaseRequireMap allKeys];
    CGFloat yCellNum = leaseRequireMapArr.count/4 + (leaseRequireMapArr.count%4==0 ? 0 : 1);
    return yCellNum*25+20+40;//20间隔空隙 40的顶部
}
#pragma mark ===
//房屋介绍 非整租
//  commonFacilitiesCode公共设施roomFacilitiesCode 房间设施 数据待改
 
//3个一行
- (CGFloat)getNotZhengZuIntroduceHeightOneTagsHeight{
    NSArray *oneArr = [self.commonFacilitiesCode allKeys];
    CGFloat oneN = oneArr.count/3 + (oneArr.count%3==0 ? 0 : 1);
    CGFloat oneH  =  oneN * 25;
    return (oneH >=40 ? oneH : 40);//基础高度40
}
- (CGFloat)getNotZhengZuIntroduceHeightTwoTagsHeight{
    NSArray *twoArr = [self.roomFacilitiesCode allKeys]; 
    CGFloat twoN = twoArr.count/3 + (twoArr.count%3==0 ? 0 : 1);
    CGFloat twoH  =  twoN * 25;
    return (twoH >=40 ? twoH : 40);//基础高度40
}

- (CGFloat)getNotZhengZuIntroduceHeightAllHeight{
    
    CGFloat textContentH =  [self getHouseIntroduceHeight];
    //
    CGFloat oneH = [self getNotZhengZuIntroduceHeightOneTagsHeight];
    CGFloat twoH = [self getNotZhengZuIntroduceHeightTwoTagsHeight];
    //
    CGFloat allH = (oneH + twoH ) + 40 + textContentH;//间隔空隙
    return allH;
}
#pragma mark ===
@end
