//
//  RemarkSetVc.m
//  Community
//
//  Created by 余莹 on 2021/5/8.
//

#import "RemarkSetVc.h"
#import "ChatManagerData.h"
@interface RemarkSetVc ()
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIView *textFBackView;
@property (nonatomic,strong) UITextField *textF;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;

@end

@implementation RemarkSetVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"备注";
    [self initView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWithBackItemHaveTitleWithStr:@""];
}
#pragma mark ==
- (void)okAction{
    if (self.textF.text.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"备注不能为空");
        return;
    }
    NSString *remarkStr  = self.textF.text;
    WEAKSELF
    [ChatManagerData changeFriendRemarkWithFriendNotUuidIsIDStr:weakSelf.idStrNotUuid  withFriendRemark:remarkStr withDic:^(NSDictionary * dic, BOOL success) {
        if (success) {
            Y_SVP_SHOW_SUCCESS_MES(@"备注成功！");
            //刷新数据notice
            Y_NSNotificationCenter_PostNotice_HaveObject_Name(ChatSetFriendRemarkName_NoticeName, remarkStr);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf popVC];
            });
        }
    }];
 
}
#pragma mark ==
- (void)initView{
    self.view.backgroundColor = Color_238GrayColor;
    [self.view addSubview:self.titleL];
    [self.view addSubview:self.textFBackView];
    [self.textFBackView addSubview:self.textF];
    [self.view addSubview:self.footerView];
    [self setUI];
}

#pragma mark ==
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_titleL.superview).offset(10);
        make.height.offset(40);
        make.right.equalTo(_titleL.superview).offset(-10);
    }];
    [_textFBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleL);
        make.height.offset(50);
        make.top.equalTo(_titleL.mas_bottom);
    }];
    [_textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_textF.superview);
        make.left.right.equalTo(_textF.superview).offset(10);
        make.height.offset(30);
    }];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_footerView.superview);
        make.top.equalTo(_textF.mas_bottom).offset(10);
        make.height.offset(90);
    }];
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"设置备注";
        _titleL.textColor = Y_ColorWith16FromRGB(0x666666);
        _titleL.font = [UIFont systemFontOfSize:13];
    }
    return _titleL;
}
- (UIView *)textFBackView{
    if (!_textFBackView) {
        _textFBackView = [[UIView alloc]init];
        _textFBackView.backgroundColor = [UIColor whiteColor];
        _textFBackView.layer.cornerRadius = 7.5;
        _textFBackView.layer.masksToBounds = YES;
    }
    return _textFBackView;
}
- (UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc]init];
        _textF.font = [UIFont systemFontOfSize:15];
        _textF.placeholder = @"请输入";
    }
    return _textF;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
        [_footerView.footerBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_footerView.footerBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
        _footerView.backgroundColor = [UIColor clearColor];
        _footerView.footerBtn.layer.cornerRadius = 22;
    }
    return _footerView;
    
}
@end
