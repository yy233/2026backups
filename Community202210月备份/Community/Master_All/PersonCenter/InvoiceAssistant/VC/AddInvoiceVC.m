//
//  AddInvoiceVC.m
//  Community
//
//  Created by 刘久炼 on 2021/2/23.
//

#import "AddInvoiceVC.h"
#import "AddInvoiceView.h"

@interface AddInvoiceVC ()


@property(nonatomic, weak) AddInvoiceView *subView;

@end

@implementation AddInvoiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加抬头";
    [self initView];
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)initView{
    [self.subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)initData{
    self.subView.companyTitleArray = [NSMutableArray array];
    self.subView.companypliceholderArray = [NSMutableArray array];
    self.subView.personTitleArray = [NSMutableArray array];
    self.subView.personpliceholderArray = [NSMutableArray array];
    self.subView.companyTitleArray = @[@[@"抬头类型",@"公司抬头",@"公司税号"],@[@"公司地址",@"公司电话",@"开户银行",@"开户账号",@"设为默认"]];
    self.subView.companypliceholderArray = @[@[@"",@"请输入公司抬头名称",@"请输入公司税号"],@[@"请输入公司地址",@"请输入公司电话",@"请输入开户银行名称",@"请输入开户账号",@""]];
    
    self.subView.personTitleArray = @[@"抬头类型",@"抬头名称",@"设为默认"];
    self.subView.personpliceholderArray = @[@"",@"建议填写个人姓名/店名",@""];
    [self.subView reloadData];
}

#pragma mark - 懒加载

- (AddInvoiceView *)subView{
    if (!_subView) {
        AddInvoiceView *view = [[AddInvoiceView alloc] init];
//        view.delegate = self;
        [self.view addSubview:view];
        _subView = view;
    }
    return _subView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
