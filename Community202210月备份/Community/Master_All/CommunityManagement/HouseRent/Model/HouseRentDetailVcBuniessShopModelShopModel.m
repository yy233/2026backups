//
//  HouseRentDetailVcBuniessShopModel.m
//  Community
//
//  Created by 余莹 on 2021/1/6.
//

#import "HouseRentDetailVcBuniessShopModelShopModel.h"

@implementation HouseRentDetailVcBuniessShopModelShopModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

- (CGFloat)getBuniessCellTitleHeight{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18]};
    CGSize size = [self.title boundingRectWithSize:CGSizeMake(Screen_W- (16.0f * 2), MAXFLOAT)
                                               options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                            attributes:attribute
                                               context:nil].size;
    
//    size.height += (10.0f);//分隔间距
    return size.height;
}
- (CGFloat)getBuniessTitleCellAllHeight{
    return [self getBuniessCellTitleHeight] + 10*3+20;
}


- (CGFloat)getBuniessCellIntroduceHeight{
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
     //高度在遇到分段时短了
     if ([self.summarize containsString:@"\n"]) {
         NSArray *huanhangfuArr = [self.summarize componentsSeparatedByString:@"\n"];
         size.height = size.height + 15*(huanhangfuArr.count-1);
         NSLog(@"------ %lu,%@",(unsigned long)huanhangfuArr.count,huanhangfuArr);
     }
     */
    
    
    
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize size = [self.summarize boundingRectWithSize:CGSizeMake(Screen_W- (16.0f * 2), MAXFLOAT)
                                               options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                            attributes:attribute
                                               context:nil].size;
    
    size.height += (10.0f * 2.0f);//分隔间距20
    
    
    return size.height;
}
- (CGFloat)getBuniessIntroduceCellAllHeight{
    return ([self getBuniessCellIntroduceHeight]+30);
}
@end
