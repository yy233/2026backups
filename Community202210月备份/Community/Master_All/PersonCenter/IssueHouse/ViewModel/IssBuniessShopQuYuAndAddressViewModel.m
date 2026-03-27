//
//  IssBuniessShopQuYuViewModel.m
//  Community
//
//  Created by 余莹 on 2021/1/23.
// 区域

#import "IssBuniessShopQuYuAndAddressViewModel.h"

@implementation IssBuniessShopQuYuAndAddressViewModel
+ (void)getIssueBuniessShopQuYuWithCityId:(NSInteger)cityId getQuYuArr:(BaseListArrAndSuccessBoolBlock)listBlock{
    NSString *url = [NSString stringWithFormat:@"proprietor/common/region?queryType=1&regionNumber=%ld",cityId];
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url  withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock block = listBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(Y_ResponsObject_dataArr,YES);
            }else{
                block(@[],NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

+ (void)getIssueBuniessShopCommunityAddressWithQuYuId:(NSInteger)quYuId getCommunityAddressArr:(BaseListArrAndSuccessBoolBlock)listBlock{
    NSString *url = [NSString stringWithFormat:@"lease/shop/getCommunity"];
//    NSString *url = [NSString stringWithFormat:@"lease/shop/getCommunity?areaId=%ld",quYuId];
//    @{@"areaId":@(quYuId)} //当前只有渝中区 500103区域才有下一级别的社区
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url  withParams:@{@"areaId":@(500103)}.mutableCopy finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock block = listBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(Y_ResponsObject_dataArr,YES);
            }else{
                block(@[],NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
@end
