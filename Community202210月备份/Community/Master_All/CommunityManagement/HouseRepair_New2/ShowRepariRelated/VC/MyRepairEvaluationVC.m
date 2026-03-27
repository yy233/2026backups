//
//  MyRepairEvaluationVC.m
//  Community
//
//  Created by 余莹 on 2022/4/11.
// 评价报事报修

#import "MyRepairEvaluationVC.h"
#import "MyRepairEvaluationView.h"
#import "MyRepairDataVM.h"

@interface MyRepairEvaluationVC () <CDZStarsControlDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) MyRepairEvaluationView *myRepairEvaluationView;

@end

@implementation MyRepairEvaluationVC

- (MyRepairEvaluationView *)myRepairEvaluationView{
    if (!_myRepairEvaluationView) {
        _myRepairEvaluationView = [[MyRepairEvaluationView alloc]initWithFrame:self.view.frame];
 
    }
    return _myRepairEvaluationView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    [self initView];
    [self initDeftData];
}
#pragma mark ==== 草稿数据展示
- (void)initDeftData{
    self.myRepairEvaluationView.starsControl.score = self.commentStatusDraft;
    self.myRepairEvaluationView.textView.text = [TextShowWithModelStr textShowWithModelStr:self.commentDraft];
    if (self.myRepairEvaluationView.textView.text.length > 0) {//有草稿数据
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.myRepairEvaluationView.textView]; //需要刷新 textview placeholder 防止和正文重叠/ setLimitLength /didchange
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self changeNavBackColorWithDDndWIsGW];

}
/** 可以重写left按钮
 */
 - (void)setupNavigationBarWithBackItemNoTitle{
 
     self.navigationController.navigationBarHidden = NO;
     if ([ThemeManager shareManager].type == ThemeType_White) {
         self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage: [Main_BackBtnImg_BlackColor imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popViewcontrollerFunc)];
     }else{
         self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage: [Main_BackBtnImg_wColor imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(popViewcontrollerFunc)];
     }
 }
//离开时 更新成普通的返回按钮 不然会连跳pop
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"";
    [self.navigationItem setBackBarButtonItem:backBtn];
    self.navigationController.navigationBarHidden = NO;
}


- (void)popViewcontrollerFunc {
    [self.view endEditing:YES];//防止键盘和弹出框占位置。
    //
    if ([self ifThisVcHaveInfo]) {//有数据 提示草稿保存弹出框
        [self showSaveTheDraftAlertV];
    }else{//无数据 直接退出
        [self popVC];
    }

}


#pragma mark ====
//当前界面有无数据bool
- (BOOL)ifThisVcHaveInfo{
    BOOL haveInfoBool = NO;
    if ( self.myRepairEvaluationView.starsControl.score <= 0 ) {
       // 星星！
    }else{
        haveInfoBool = YES;
    }
    
    if ( self.myRepairEvaluationView.textView.text.length <= 0 ) {
        //内容
    }else{
        haveInfoBool = YES;
    }
    return haveInfoBool;
}

//提示草稿保存弹出框
- (void)showSaveTheDraftAlertV{
    WEAKSELF
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确定退出本次评价吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存草稿" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DLog(@"保存草稿");
        [self saveThisInfo];
    }];
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"确认退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"退出");
        [weakSelf popVC];
    }];
    
    [alertC addAction:saveAction];
    [alertC addAction:exitAction];
    alertC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertC animated:YES completion:nil];
}



//保存草稿
- (void)saveThisInfo{
    
    if (self.myRepairEvaluationView.starsControl.score<=0) {
        self.myRepairEvaluationView.starsControl.score=0;
    }
    
    WEAKSELF
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue: [TextShowWithModelStr textShowWithModelStr:self.myRepairEvaluationView.textView.text]  forKey:@"appraise"];
    [parms setValue:@(self.myRepairEvaluationView.starsControl.score)  forKey:@"status"];
    [parms setValue:@(self.thisEvalutionUseRepairID) forKey:@"id"];
    [MyRepairDataVM myRepairEndWithSaveTheDraftEvaluationInfoDic:parms  withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            //success
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(@"草稿已保存！");
                if(isNotNil(self.popVcWithNeedUpDateBlock)){//需要刷新数据 直接点进评价页时用到参数
                    self.popVcWithNeedUpDateBlock();
                }
                [weakSelf popVC];
            });
            
        }else{
        }
    }];
    

}

#pragma mark ==
- (void)initView{
    [self.view addSubview:self.myRepairEvaluationView];
    [self.myRepairEvaluationView.footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.myRepairEvaluationView.starsControl.delegate = self;

}

#pragma mark ==
- (void)starsControl:(CDZStarsControl *)starsControl didChangeScore:(CGFloat)score{
    NSLog(@" starsControl  ==  %lf",score);
}

- (void)footerBtnAction{
    WEAKSELF
    DLog(@"发布评价");
    if ( self.myRepairEvaluationView.starsControl.score <= 0 ) {
        Y_SVP_SHOW_ERR_MES(@"请点亮星星！");
        return;
    }
    
    if ( self.myRepairEvaluationView.textView.text.length <= 0 ) {
        Y_SVP_SHOW_ERR_MES(@"请输入评价内容！");
        return;
    }
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue: [TextShowWithModelStr textShowWithModelStr:self.myRepairEvaluationView.textView.text]  forKey:@"appraise"];
    [parms setValue:@(self.myRepairEvaluationView.starsControl.score)  forKey:@"status"];
    [parms setValue:@(self.thisEvalutionUseRepairID) forKey:@"id"];
    [MyRepairDataVM myRepairEndWithUpEvaluationInfoDic:parms withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            //success
            dispatch_async(dispatch_get_main_queue(), ^{
                if(isNotNil(self.popVcWithNeedUpDateBlock)){
                    self.popVcWithNeedUpDateBlock();
                }
                Y_SVP_SHOW_SUCCESS_MES(@"评价提交成功！");
                [weakSelf popVC];
            });
            
        }else{
        }
    }];
    
    
}
@end
