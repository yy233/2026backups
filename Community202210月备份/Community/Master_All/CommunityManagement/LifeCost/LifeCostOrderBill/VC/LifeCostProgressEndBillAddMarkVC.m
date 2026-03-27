//
//  LifeCostProgressEndBillAddMarkVC.m
//  Community
//
//  Created by 余莹 on 2021/1/13.
//

#import "LifeCostProgressEndBillAddMarkVC.h"

#define H_SubBtn                30
#define Tag_SubBtn              360
#define Color_SubBtn_Selected   Y_RGBA(38, 114, 249, 1)

@interface LifeCostProgressEndBillAddMarkVC ()
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UITextField *markTextField;
@property (nonatomic,strong) UIView *lineV;
@property (nonatomic,strong) UILabel *titleLabelTwo;
@property (nonatomic,strong) UIView *subOldMarkbackView;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
//
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@end

@implementation LifeCostProgressEndBillAddMarkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"标签";
    self.dataSourceArr = [NSMutableArray array];
    [self initView];
    [self initData];
}
#pragma mark ==
- (void)footerSaveAction{
    NSLog(@"footerSaveAction");
    if (self.markTextField.text.length==0) {
        Y_SVP_SHOW_INFO_MES(@"标签为空");
        return;
    }
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(self.orderId) forKey:@"orderId"];
    [parms setValue:self.markTextField.text forKey:@"tally"];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueue:URL_Life_addOrderMarkOrNote withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                Y_SVP_SHOW_SUCCESS_MES(@"标签添加成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.markTextField.text forKey: Notice_UserInfo_Key];
                    Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(LifeCost_BillMark_Save_Notice_Name, userInfo);
                    [self.navigationController popViewControllerAnimated:YES];
                 });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma mark ==
- (void)initData{
    self.dataSourceArr = [NSMutableArray arrayWithObjects:@"家庭账本",@"公司账本",@"个人账本",@"其他",@"其他账账本",@"其他账本本",@"其他账本", @"其他账本本",@"其他账本本本本本",@"其他账本本本",@"其他账本本",@"其他账本",@"其他账本本本",@"其他账本本",@"其他账本",@"其他账本本本",nil];
    [self markBackViewAddSubView];
    
}
#pragma mark===
- (void)subBtnAction:(UIButton *)sender{
    NSInteger index = sender.tag - Tag_SubBtn;
    NSLog(@"subBtnAction == %@",self.dataSourceArr[index]);
    self.markTextField.text = [NSString stringWithFormat:@"%@",self.dataSourceArr[index]];
    //
    for (UIButton *subB in    sender.superview.subviews) {
        if (subB.tag == sender.tag) {
            subB.selected = YES;
        }else{
            subB.selected = NO;
        }
    }
}
- (void)markBackViewAddSubView{
    NSInteger count  =  self.dataSourceArr.count;
    if (count>=6) {
//        count = 6;//限制数量 
    }
    float subAllW = 0;//总宽度
    float subThisSectionW = 0;
    float subbecomeBigW = 10;
    float subJianGeW = 10;//间距
    float subJianGeH = 10;
    for (int  i=0; i <count; i ++) {
        UIButton *btn = [self baseBtn];
        [btn setTitle:[NSString stringWithFormat:@"%@",self.dataSourceArr[i]] forState:UIControlStateNormal];
        btn.layer.cornerRadius = H_SubBtn*0.5;
        btn.layer.masksToBounds = YES;
        btn.tag = i + Tag_SubBtn;
        //
        float subBtnWidth =  [Tool getTextWidthWhenOneLineWithTextStr:self.dataSourceArr[i] withFont:[UIFont systemFontOfSize:14]] + subbecomeBigW;
        //
        if ((subAllW+subBtnWidth)>(Screen_W-32-subJianGeW*3)) {//大约3个分隔 取3个分隔的冗余
            NSInteger hangNum = (subAllW+subBtnWidth) / (Screen_W-32);//第几行
            NSInteger hangNumYue = (subAllW+subBtnWidth) - hangNum*(Screen_W-32);//余数
            if (hangNumYue<=subBtnWidth) {
                //新行 换一行
                subThisSectionW = 0;
            }
            //
            btn.frame = CGRectMake(subThisSectionW,hangNum*(H_SubBtn+subJianGeH), subBtnWidth, H_SubBtn);
            //
            subThisSectionW = subThisSectionW + subJianGeW +subBtnWidth;//当前行
            subAllW = subAllW + subJianGeW + subBtnWidth;//总
        }else{
   
            btn.frame = CGRectMake(subAllW, 0, subBtnWidth, H_SubBtn);
            subAllW = subAllW + subJianGeW + subBtnWidth;
         
        }
        [self.subOldMarkbackView addSubview:btn];
    }
}
- (UIButton *)baseBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:Color_SubBtn_Selected] forState:UIControlStateSelected];
    [btn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [ThemeManager shareManager].mainTextColor.CGColor;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
#pragma mark===
- (void)initView{
    [self.view addSubview:self.titleL];
    [self.view addSubview:self.markTextField];
    [self.view addSubview:self.lineV];
    [self.view addSubview:self.titleLabelTwo];
    [self.view addSubview:self.subOldMarkbackView];
    [self.view addSubview:self.footerView];
    
    [self setTopUI];
    [self setCneterUI];
    [self setBottomUI];
}
- (void)setTopUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview.mas_top).offset(20);
        make.left.equalTo(_titleL.superview.mas_left).offset(16);
        make.right.equalTo(_titleL.superview.mas_right).offset(-16);
        make.height.offset(20);
    }];
    [_markTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom).offset(20);
        make.left.equalTo(_markTextField.superview.mas_left).offset(16);
        make.right.equalTo(_markTextField.superview.mas_right).offset(-16);
        make.height.offset(40);
    }];
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_markTextField.mas_bottom);
        make.left.equalTo(_markTextField.mas_left);
        make.right.equalTo(_markTextField.mas_right);
        make.height.offset(1);
    }];
}
- (void)setCneterUI{
    [_titleLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineV.mas_bottom).offset(20);
        make.left.equalTo(_lineV.mas_left);
        make.right.equalTo(_lineV.mas_right);
        make.height.offset(20);
    }];
    [_subOldMarkbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabelTwo.mas_bottom).offset(20);
        make.left.equalTo(_lineV.mas_left);
        make.right.equalTo(_lineV.mas_right);
        make.height.equalTo(_subOldMarkbackView.superview.mas_height).multipliedBy(0.5);
    }];
    [self markBackViewAddSubView];
}
- (void)setBottomUI{
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_footerView.superview.mas_bottom).offset(-30);
        make.left.equalTo(_footerView.superview.mas_left).offset(16);
        make.right.equalTo(_footerView.superview.mas_right).offset(-16);
        make.height.offset(90);
    }];
    
}
#pragma mark ==
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font  = [UIFont boldSystemFontOfSize:16];
        _titleL.text = @"标签";
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.textAlignment = NSTextAlignmentLeft;
    }
    return _titleL;
}
- (UITextField *)markTextField{
    if (!_markTextField) {
        _markTextField = [[UITextField alloc]init];
        _markTextField.textColor = [ThemeManager shareManager].mainTextColor;
        _markTextField.font = [UIFont systemFontOfSize:14];
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"输入标签" attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7]}];
        _markTextField.attributedPlaceholder = placeholderString;
    }
    return _markTextField;
}
- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]init];
        _lineV.backgroundColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.2];
    }
    return _lineV;
}
- (UILabel *)titleLabelTwo{
    if (!_titleLabelTwo) {
        _titleLabelTwo = [[UILabel alloc]init];
        _titleLabelTwo.font  = [UIFont boldSystemFontOfSize:16];
        _titleLabelTwo.text = @"我的标签";
        _titleLabelTwo.textColor = [ThemeManager shareManager].mainTextColor;
        _titleLabelTwo.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabelTwo;
}
- (UIView *)subOldMarkbackView{
    if (!_subOldMarkbackView) {
        _subOldMarkbackView = [[UIView alloc]init];
    }
    return _subOldMarkbackView;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0,0, Screen_W, 90)];
        [_footerView setBtnFram:CGRectMake(16, 0, Screen_W-32, 50)];
        [_footerView.footerBtn setTitle:@"保存" forState:UIControlStateNormal];
        _footerView.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
        [_footerView.footerBtn addTarget:self action:@selector(footerSaveAction) forControlEvents:UIControlEventTouchUpInside];;
    }
    return _footerView;
}

@end
