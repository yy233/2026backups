//
//  TopOrUregentInfoDetailModel.m
//  Community
//  消息详情
//  Created by 余莹 on 2020/12/21.
//

#import "TopOrUregentInfoDetailModel.h"

@implementation TopOrUregentInfoDetailModel

- (NSInteger)gettitleLabelShowHeight{
    NSString *text =  self.pushTitle;
    CGSize labelSize = CGSizeMake(Screen_W-2*16-40, MAXFLOAT);
    CGRect rect = [text boundingRectWithSize:labelSize
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}
                                                        context:nil];
    CGSize size = CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
    return size.height+5;
}
@end
