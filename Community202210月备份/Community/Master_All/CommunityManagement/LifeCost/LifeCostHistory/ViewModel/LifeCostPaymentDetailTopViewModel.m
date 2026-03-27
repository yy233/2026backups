//
//  LifeCostHistoryTopViewModel.m
//  Community
//
//  Created by 余莹 on 2021/7/7.
//

#import "LifeCostPaymentDetailTopViewModel.h"

@implementation LifeCostPaymentDetailTopViewModel
/**
 查询全部户号  
 */
+ (void)getHuHaoGetAllList:(BaseListArrAndSuccessBoolBlock)listBlock{
   [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Life_selectFamilyId withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
 
       if (isNotNil(responsObject)) {
           if (Y_IS_Success) {
               listBlock(Y_ResponsObject_dataArr,YES);
               dispatch_async( dispatch_get_main_queue(), ^{
               });
           }else{
               Y_SVP_SHOW_ERR_MESSAGE
               listBlock(@[],NO);
           }
       }else{
           Y_SVP_SHOW_ERR_DESCRIPTION
           listBlock(@[],NO);
       }
   }];
}
/**
 /proprietor/livingpaymentquery/selectFamilyId____{
    code = 0;
    data =     (
                {
            companyName = "重庆江南水务公司";
            familyId = 1056134646;
            typeName = "水费";
        },
                {
            companyName = "国家电网重庆市电力公司";
            familyId = 105613516;
            typeName = "电费";
        },
                {
            companyName = "重庆燃气集团公司";
            familyId = 154613516;
            typeName = "燃气费";
        }
    );*/
@end
