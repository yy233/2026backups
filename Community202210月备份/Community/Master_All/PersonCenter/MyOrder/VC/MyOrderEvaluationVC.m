//
//  MyOrderEvaluationVC.m
//  Community
//
//  Created by 余莹 on 2021/5/28.
//

#import "MyOrderEvaluationVC.h"
#import "MyOrderEvaluateMessageModel.h"

@interface MyOrderEvaluationVC () <UITextViewDelegate>
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@end

@implementation MyOrderEvaluationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    [self initView];
    [self initData];
    if (self.orderModel.appStateNum == MyOrderListCell_Type_EvaluationEnd) {//已经评价的状态
        self.textView.userInteractionEnabled = NO;
        self.textView.editable = NO;
        self.footerView.hidden = YES;
    }else if(self.orderModel.appStateNum == MyOrderListCell_Type_WillEvaluation){
        self.textView.userInteractionEnabled = YES;
        self.textView.editable = YES;
        self.footerView.hidden = NO;
    }


}
- (void)initData{
//    url=http://yhs0.cn.utools.club/services/order/shopEvaluation/getOrderUuidEvaluation?uuid=a675750fa74feb884a9bdbdbcbb401____{
    NSString *url = [NSString stringWithFormat:@"%@?uuid=%@",URL_BuniessService_GetOrderEvaluation,[TextShowWithModelStr textShowWithModelStr:self.orderModel.uuid]];
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueueWtihBuniessShopTypeUrl:url  withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        /**
         po responsObject
        {
            code = 0;
            data =     {
                createTime = "2021-05-29T17:24:40";
                evaluateLevel = "<null>";
                evaluateMessage = "1234568\U8bc4\U8bba";
                id = 30;
                image = "<null>";
                list = "<null>";
                name = "<null>";
                orderUuid = a675750fa74feb884a9bdbdbcbb401;
                shopUuid = 0c9b7441285b41fbb48f6f51be2df002;
                userUuid = "<null>";
                uuid = "<null>";
            };
            message = "<null>";
         */
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *getDic = Y_ResponsObject_dataDic;
                MyOrderEvaluateMessageModel *model = [MyOrderEvaluateMessageModel mj_objectWithKeyValues:getDic];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.textView.text = [TextShowWithModelStr textShowWithModelStr:model.evaluateMessage];
                    if (self.textView.text.length>0) {
                        self.textView.editable = NO;
                        self.textView.userInteractionEnabled = NO;
                        self.footerView.hidden = YES;
                    }else{
                        self.textView.editable = YES;
                        self.textView.userInteractionEnabled = YES;
                        self.footerView.hidden = NO;
                    }
                
                });
             }else{
                 Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
             Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];

}
- (void)footerBtnOkAction{
    if (self.textView.text.length==0) {
        Y_SVP_SHOW_ERR_MES(@"请输入评价");
        return;
    }
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:[TextShowWithModelStr textShowWithModelStr:self.orderModel.uuid ] forKey:@"orderUuid"];
    [parms setValue:[TextShowWithModelStr textShowWithModelStr:self.orderModel.shopUuid] forKey:@"shopUuid"];
    [parms setValue:self.textView.text forKey:@"evaluateMessage"];
//    [parms setValue:@(0) forKey:@"evaluateLevel"];//评价等级0-5
    
    
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueueWtihBuniessShopTypeUrl:URL_BuniessService_OrderToSaveEvaluation  withParams:parms finished:^(id responsObject, NSError *error) {
        /**
         */
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                Y_NSNotificationCenter_PostNotice_NilObject_Name(Buniess_PopToListVC_WithReloadList);
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_SUCCESS_MES(@"提交成功！");
                    [self popVC];
                });
             }else{
                 Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
             Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
    
}
 
- (void)initView{
    [self.view addSubview:self.textView];
    [self.view addSubview:self.footerView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_textView.superview).offset(10);
        make.height.equalTo(_textView.superview).multipliedBy(0.4);
        make.right.equalTo(_textView.superview).offset(-10);
    }];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_footerView.superview);
        make.height.offset(90);
        make.top.equalTo(_textView.mas_bottom).offset(30);
    }];
    
}
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.delegate = self;
        _textView.font = [UIFont boldSystemFontOfSize:16];
        _textView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2];
    }
    return _textView;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0,0, Screen_W-32, 90)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"提交"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnOkAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

@end
