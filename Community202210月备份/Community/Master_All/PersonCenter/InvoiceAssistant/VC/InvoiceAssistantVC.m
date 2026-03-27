//
//  InvoiceAssistantVC.m
//  Community
//
//  Created by 余莹 on 2021/2/23.
//  发票助手

#import "InvoiceAssistantVC.h"
#import "InvoiceAssistantView.h"

#import "AddInvoiceVC.h"
#import "InvoiceAssistantDetailVC.h"
@interface InvoiceAssistantVC ()<InvoiceAssistantViewDelegate>

@property(nonatomic, weak) InvoiceAssistantView *subView;

@end

@implementation InvoiceAssistantVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发票助手";
    [self initView];
}

- (void)initView{
    [self.subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 懒加载

- (InvoiceAssistantView *)subView{
    if (!_subView) {
        InvoiceAssistantView *view = [[InvoiceAssistantView alloc] init];
        view.delegate = self;
        [self.view addSubview:view];
        _subView = view;
    }
    return _subView;
}


#pragma mark - InvoiceAssistantViewDelegate

- (void)addBtnClicked{
    AddInvoiceVC *vc = [[AddInvoiceVC alloc] init];
    [self pushVc:vc];
}


- (void)cellCliced{
    InvoiceAssistantDetailVC *vc = [[InvoiceAssistantDetailVC alloc] init];
    [self pushVc:vc];
}




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
