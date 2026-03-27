//
//  SmallShopCartVC.m
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import "SmallShopCartBaseVC.h"

@interface SmallShopCartBaseVC () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation SmallShopCartBaseVC
- (NSMutableArray *)goodsArr{
    if (!_goodsArr) {
        _goodsArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _goodsArr;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = Y_ColorWith16FromRGB(0xF0F1F6);
    }
    return _tableView;
}
- (CartVcSubBaseFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[CartVcSubBaseFooterView alloc]initWithFrame:CGRectZero];
        [_footerView.allChooseBtn addTarget:self action:@selector(touchAllChooseBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView.payBtn addTarget:self action:@selector(touchPayBtnAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _footerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseView];
   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteStyle];//防止实名流程后nav变色
}
- (void)initBaseView{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    //
    UIView *hV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 20)];
    hV.backgroundColor = Y_ColorWith16FromRGB(0xF0F1F6);
    self.tableView.tableHeaderView = hV;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 20)];
    //
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_tableView.superview);
        make.bottom.equalTo(_tableView.superview).offset(-60-kGHSafeAreaBottomHeight);
    }];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {//lay做line 1
        make.left.equalTo(_footerView.superview).offset(-1);
        make.right.equalTo(_footerView.superview).offset(+1);
        make.bottom.equalTo(_footerView.superview).offset(-1-bottom_height);
        make.height.offset(60);
    }];
}

- (void)hiddenAllChooseView{
    self.footerView.hidden = YES;//隐藏全选view
}
- (void)showAllChooseBtnView{
    self.footerView.hidden = NO;//显示全选view
}

- (void)hiddenAllChooseOnlyBtn{
    self.footerView.allChooseBtn.hidden = YES;//隐藏全选子按钮
}

- (void)touchPayBtnAction{
    DLog(@"结算");
}
- (void)touchAllChooseBtnAction{
    DLog(@"全选");
    self.footerView.allChooseBtn.selected = ! self.footerView.allChooseBtn.selected;
}


- (void)fillAllMoneyNumWithOnlyMoneyStr:(NSString *)moneyStr{
    self.footerView.moneyL.attributedText = [self attributeWithOneStr:@"¥" withSecondStr:moneyStr];
}
//列表页
- (void)fillCartListActivalInfoWithShowStr:(NSString *)payDtoLabelShowStr{
    self.footerView.payDtoInfoL.text = payDtoLabelShowStr;
}
//结算页
- (void)fillOneGoodsDetailThisActualInfoWithPayDto:(SmallShopCartSubPayDtoModel *)payDtoModel{
    [self.footerView fillPayDtoInfoLWithPayDto:payDtoModel];
}
//拼团footerView颜色更改
- (void)footerViewIsRedOrangeBackColor{
    [self.footerView footerViewIsRedOrangeBackColor];
}

- (NSAttributedString*)attributeWithOneStr:(NSString*)first withSecondStr:(NSString*)second{
    NSMutableAttributedString* astring = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",first,second]];
    NSRange range1 = NSMakeRange(0, first.length);
    NSRange range2 = NSMakeRange(first.length, (first.length + second.length)-1);
    //
    NSDictionary* attributes1 = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:9.0]  };
    NSDictionary* attributes2 = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0]  };
    [astring addAttributes:attributes1 range:range1];
    [astring addAttributes:attributes2  range:range2];
    return astring;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  (section==0 ? 1 : 10);//有20headerv
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/


@end
