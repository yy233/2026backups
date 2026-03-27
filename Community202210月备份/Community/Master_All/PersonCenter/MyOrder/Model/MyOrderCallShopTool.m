//
//  MyOrderCallShopTool.m
//  Community
//
//  Created by 余莹 on 2021/5/29.
// 致电商家

#import "MyOrderCallShopTool.h"

@implementation MyOrderCallShopTool
+ (void)callShopWithOrderModel:(MyOrderModel *)model{
    NSString *shopPhone = [TextShowWithModelStr textShowWithModelStr:model.shopPhone];
    [self callPhoneWithStr:shopPhone];
}

+ (void)callPhoneWithStr:(NSString *)phoneStr{
    NSMutableString *callStr=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneStr];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr] options:@{} completionHandler:nil];

    /**
     NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneStr];
     UIWebView * callWebview = [[UIWebView alloc] init];
     [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
     [self.view addSubview:callWebview];
     */
    
}
@end
