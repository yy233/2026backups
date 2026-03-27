//
//  CommunityFunListModel.m
//  Community
//
//  Created by 余莹 on 2020/12/19.
//

#import "CommunityFunListViewModel.h"
#define PageSize_CommunityFunList 10

@implementation CommunityFunListViewModel
+ (void)comunityFunListInitWithListBlock:(ListBlock)listBlock{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:@(1) forKey:@"page"];
    [parms setValue:@(PageSize_CommunityFunList) forKey:@"size"];
    [CommunityFunListViewModel  initParms:parms WithListBlock:listBlock];
}
+ (void)comunityFunListInitWithSearchStr:(NSString *)searchStr WithListBlock:(ListBlock)listBlock{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:@(1) forKey:@"page"];
    [parms setValue:@(PageSize_CommunityFunList) forKey:@"size"];
    [parms setValue:searchStr forKey:@"headline"];
    [CommunityFunListViewModel  initParms:parms WithListBlock:listBlock];
}
+ (void)initParms:(NSMutableDictionary *)parms WithListBlock:(ListBlock)listBlock{
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Community_Fun_FindList withParams:parms finished:^(id responsObject, NSError *error) {
        ListBlock block = listBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *reustDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                if ([reustDic[@"list"] isKindOfClass:[NSArray class]]) {
                }else{
                    return  block(NO,[NSArray array],0);;
                }
                NSArray *listArr = [NSArray arrayWithArray:reustDic[@"list"]];
                NSInteger total = [reustDic[@"total"] intValue];
                block(YES,listArr,total);
            }else{
                block(NO,[NSArray array],0);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(NO,[NSArray array],0);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
//更新
+ (void)comunityFunListWithPageNum:(NSInteger)pageNum UpdateWithListBlock:(ListBlock)listBlock{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:@(pageNum) forKey:@"page"];
    [parms setValue:@(PageSize_CommunityFunList) forKey:@"size"];
    [CommunityFunListViewModel  updateParms:parms WithListBlock:listBlock];
}
+ (void)comunityFunListWithPageNum:(NSInteger)pageNum UpdateWithSearchStr:(NSString *)searchStr WithListBlock:(ListBlock)listBlock{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:@(pageNum) forKey:@"page"];
    [parms setValue:@(PageSize_CommunityFunList) forKey:@"size"];
    [parms setValue:searchStr forKey:@"headline"];
    [CommunityFunListViewModel  updateParms:parms WithListBlock:listBlock];
}
+ (void)updateParms:(NSMutableDictionary *)parms WithListBlock:(ListBlock)listBlock{
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_Community_Fun_FindList withParams:parms finished:^(id responsObject, NSError *error) {
        ListBlock block = listBlock;
        if (isNotNil(responsObject)) {
            NSDictionary *reustDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
            if (Y_IS_Success) {
                NSArray *listArr = [NSArray arrayWithArray:reustDic[@"list"]];
                NSInteger total = [reustDic[@"total"] intValue];
                block(YES,listArr,total);
            }else{
                block(NO,[NSArray array],0);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(NO,[NSArray array],0);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
@end
