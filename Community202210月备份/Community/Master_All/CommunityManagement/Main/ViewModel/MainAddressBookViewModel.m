//
//  MainAddressBookViewModel.m
//  Community
//
//  Created by 余莹 on 2020/11/27.
//

#import "MainAddressBookViewModel.h"

@implementation MainAddressBookViewModel

+ (void)getAddressBookListArrWithBlock:(AddressBookListBlock)block{
    AddressBookListBlock listBlock = block;
    [[ToolOfNetWork sharedTools] YrequestGetURLNotMainQueue:URL_MAIN_ADDRESS_BOOK_ALL_LIST
                                     withParams:@{@"id":@([ShareUserInfo sharedUserInfo].commuityInfo.ID)}.mutableCopy
                                       finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                listBlock(Y_ResponsObject_dataArr);
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
+ (void)getAddressBookDetailPhoneArrWithDepartmentId:(NSInteger)departmentId
                                    detailPhoneblock:(AddressBookDetailPhoneBlock)block{
    AddressBookDetailPhoneBlock phoneBlock = block;
    [[ToolOfNetWork sharedTools] YrequestGetURL:URL_MAIN_ADDRESS_BOOK_DETAILS_PHONE
                                     withParams:@{@"id":@(departmentId)}.mutableCopy
                                       finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                phoneBlock(Y_ResponsObject_dataArr);
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

//
+ (void)getAddressBookTopShowInfoWithCommunityId:(NSInteger)communityId withBlock:(BaseDicAndSuccessBoolBlock)block{
    
    [[ToolOfNetWork sharedTools] YrequestGetURL:@"proprietor/community/company"
                                     withParams:@{@"communityId":@(communityId)}.mutableCopy
                                       finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                block(dic,YES);
            }else{
                block(@{},NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
//

@end
