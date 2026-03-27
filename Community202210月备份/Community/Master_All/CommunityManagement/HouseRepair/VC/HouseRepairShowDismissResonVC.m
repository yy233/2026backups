//
//  HouseRepairShowDismissResonVC.m
//  Community
//
//  Created by 余莹 on 2021/3/25.
//

#import "HouseRepairShowDismissResonVC.h"

@interface HouseRepairShowDismissResonVC ()
@property (nonatomic,strong) UITextView *textView;
@end

@implementation HouseRepairShowDismissResonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"驳回理由";
    [self initView];
    [self initD];
}
- (void)initD{
    WEAKSELF
   [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Get_House_Repari_ShowDismissReason withParams:@{@"id":@(self.IDNum)}.mutableCopy finished:^(id responsObject, NSError *error) {
       if (isNotNil(responsObject)) {
           if (Y_IS_Success) {
               dispatch_async(dispatch_get_main_queue(), ^{
                   weakSelf.textView.text = Y_ResponsObject_dataStr;// Y_ResponsObject_messageStr;
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
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_textView.superview).insets(UIEdgeInsetsMake(10, 16, 20, 16));
    }];
}
#pragma mark ==
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.textColor = Color_238GrayColor;
    }
    return _textView;
}
@end
