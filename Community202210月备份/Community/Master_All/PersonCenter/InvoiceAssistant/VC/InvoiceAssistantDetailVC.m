//
//  InvoiceAssistantDetailVC.m
//  Community
//
//  Created by 刘久炼 on 2021/2/24.
//

#import "InvoiceAssistantDetailVC.h"
#import "InvoiceAssistantDetailView.h"

@interface InvoiceAssistantDetailVC ()

@property(nonatomic, strong) InvoiceAssistantDetailView *subView;

@end

@implementation InvoiceAssistantDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发票助手";
    
    [self initView];
    [self initRightBar];
    // Do any additional setup after loading the view.
}

- (void)initRightBar{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    rightBtn.bounds = CGRectMake(0 , 0, 24, 24);
    UIBarButtonItem *infoRightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:infoRightBarItem animated:YES];
}


- (void)initView{
    [self.subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 懒加载

- (InvoiceAssistantDetailView *)subView{
    if (!_subView) {
        _subView = [[InvoiceAssistantDetailView alloc] init];
//        _subView.delegate = self;
        [self.view addSubview:_subView];
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
