//
//  ComplaintsSuggestionsVC.m
//  Community
//
//  Created by 余莹 on 2021/3/30.
//

#import "ComplaintsSuggestionsVC.h"
#import "ComplanintsSuggesstionsModel.h"
@interface ComplaintsSuggestionsVC ()

@end

@implementation ComplaintsSuggestionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投诉建议";
    [self reUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
}
- (void)reUI{
    [self.adviceView.complaintsBtn newAnBtnWithTextStr:@"投诉"];//type=1
    [self.adviceView.adviceBtn newAnBtnWithTextStr:@"建议"];//type=2
}
#pragma mark ====
- (void)sendAllAdvice{
    if (self.adviceView.textView.text.length<=0) {
        Y_SVP_SHOW_INFO_MES(@"请输入文本");
        return;
    }
    if (self.adviceView.textView.text.length>=200) {
        Y_SVP_SHOW_INFO_MES(@"当前文本限制200");
        return;
    }
    NSInteger isStatus = 0;
    if (self.adviceView.adviceBtn.selected==YES) {
        isStatus = 2;
    }else{
        isStatus = 1;
    }
    NSString *strWithUrl = @"";
    if (self.imgUrlArr.count>0) {
        strWithUrl = [NSString stringWithFormat:@"%@",[self.imgUrlArr componentsJoinedByString:@","]];
    }
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:@(isStatus) forKey:@"type"];
    [parms setValue:@([ShareUserInfo sharedUserInfo].commuityInfo.ID) forKey:@"communityId"];
    [parms setValue:strWithUrl forKey:@"images"];
    [parms setValue:self.adviceView.textView.text forKey:@"content"];
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [ComplanintsSuggesstionsModel sendAllCompanintParmsWithParms:parms withBlock:^(NSDictionary * dic, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
        });
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(@"操作成功");
                [self popVC];
            });
        }else{
            Y_SVP_SHOW_ERR_MES(@"提交失败");
        }
    }];
}
- (void)sendImg:(UIImage *)img{
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [ComplanintsSuggesstionsModel sendCompanintsImgWithImg:img withBlock:^(NSDictionary * dic, BOOL success) { //此接口 dic 得arr 是以,分割的字符串。//当前只做一个图的处理
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_DISMISS
            });
            if ([[dic allKeys] containsObject:@"data"]) {
                NSMutableArray *getDataArr =  [[NSMutableArray alloc]init];;
                NSString *imgUrlStr = @"";
                if ([[dic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                    getDataArr =  [[dic allKeys] containsObject:@"data"]?[dic objectForKey:@"data"]:[NSMutableArray array];
                    imgUrlStr = getDataArr.firstObject;
                }
                if ([[dic objectForKey:@"data"] isKindOfClass:[NSString class]]) {
                    imgUrlStr = [NSString stringWithString:[dic objectForKey:@"data"]];
                }
                [self.imgUrlArr addObject:imgUrlStr];
            }else{
                Y_SVP_SHOW_ERR_MES(@"数据有误");
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imgSaveArr addObject:img];
                [self.collectionView reloadData];
            });
        }else{
            Y_SVP_SHOW_ERR_MES(@"图片提交失败")
        }
    }];
}

#pragma mark ===
 
@end
