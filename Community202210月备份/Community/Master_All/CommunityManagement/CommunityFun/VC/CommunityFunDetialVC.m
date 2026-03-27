//
//  CommunityFunDetialVC.m
//  Community
//
//  Created by 余莹 on 2020/12/19.
//

#import "CommunityFunDetialVC.h"
#import "CommunityFunDetialView.h"

@interface CommunityFunDetialVC ()
@property (nonatomic,strong) CommunityFunDetialView *detailView;
@end

@implementation CommunityFunDetialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    
}
- (void)initView{
    self.title = @"详情";
    [self.view addSubview:self.detailView];
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_detailView.superview);
    }];
}
#pragma mark ==
- (void)initData{
    Y_SVP_SHOW_MES_IsLoading_15Delay
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Community_Fun_findFunDetail withParams:@{@"id":@(self.id)}.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
        });
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.detailView.model = [CommunityFunModel mj_objectWithKeyValues:Y_ResponsObject_dataDic];
                });
            }else{
                Y_SVP_SHOW_SUCCESS_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];

}

#pragma mark ==
- (CommunityFunDetialView *)detailView{
    if (!_detailView) {
        _detailView = [[CommunityFunDetialView alloc]initWithFrame:self.view.frame];
        _detailView.forwardingBtnActionBlock = ^{
            DLog(@"转发按钮");
        };
    }
    return _detailView;
}
@end
