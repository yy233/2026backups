//
//  AccountCancelVC.m
//  Community
//
//  Created by 刘久炼 on 2021/2/27.
//

#import "AccountCancelVC.h"
#import "AccountCancelView.h"

@interface AccountCancelVC ()

@property(nonatomic, strong) AccountCancelView *subView;

@end

@implementation AccountCancelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户注销";
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)initView{
    [self.subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 懒加载

- (AccountCancelView *)subView{
    if (!_subView) {
        _subView = [[AccountCancelView alloc] init];
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
