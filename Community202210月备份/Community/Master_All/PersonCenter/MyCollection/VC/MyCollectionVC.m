//
//  MyCollectionVC.m
//  Community
//
//  Created by 余莹 on 2021/2/23.
// 我的收藏

#import "MyCollectionVC.h"
#import "MyCollectionView.h"

#import "MyCollectionModel.h"

@interface MyCollectionVC ()
@property(nonatomic, strong) MyCollectionView *subView;

@end

@implementation MyCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    [self initView];
    [self initRightBar];
    [self initData];
}

- (void)initView{
    [self.subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)initRightBar{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn setTitleColor: [Tool getColorWithHexString:@"#000000"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClicekd:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = FontSize_Vip_Nomail(15);
    rightBtn.bounds = CGRectMake(0 , 0, 24, 24);
    UIBarButtonItem *infoRightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:infoRightBarItem animated:YES];
}

#pragma mark - 数据

- (void)initData{
    self.subView.dataArray = [NSMutableArray array];
    for (int i = 0; i< 2; i ++) {
        MyCollectionModel *model = [[MyCollectionModel alloc] init];
        [self.subView.dataArray addObject:model];
    }
    [self.subView reloadData];
}

#pragma mark - 懒加载

- (MyCollectionView *)subView{
    if (!_subView) {
        _subView = [[MyCollectionView alloc] init];
//        view.delegate = self;
        [self.view addSubview:_subView];
    }
    return _subView;
}

#pragma mark - 按钮点击

- (void)rightBtnClicekd: (UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        [self.subView editClickedWithStatus:MyCollectionViewEdit];
    }else{
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        [self.subView editClickedWithStatus:MyCollectionViewNormal];
    }
    
}


#pragma mark - InvoiceAssistantViewDelegate

//- (void)addBtnClicked{
//    AddInvoiceVC *vc = [[AddInvoiceVC alloc] init];
//    [self pushVc:vc];
//}
//
//
//- (void)cellCliced{
//    InvoiceAssistantDetailVC *vc = [[InvoiceAssistantDetailVC alloc] init];
//    [self pushVc:vc];
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteStyle];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
