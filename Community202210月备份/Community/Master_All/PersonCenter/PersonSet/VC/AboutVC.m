//
//  AboutVC.m
//  Community
//
//  Created by 刘久炼 on 2021/2/27.
//

#import "AboutVC.h"

#import "CertificationVC.h"
#import "ZYDisclaimerVC.h"

#import "PersonInfoNormalCell.h"
#import "AboutTopCell.h"

@interface AboutVC ()

@property(nonatomic, strong) NSMutableArray *titleArray;
@end

static NSString *const cellID = @"PersonInfoNormalCell";
static NSString *const topCellID = @"AboutTopCell";
@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self setupNavigationBarWhiteStyle];
    
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
}

- (void)initView{
    self.title = @"关于未来物服";
//    self.tableView.backgroundColor = Color_245Gray;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone
    self.tableView.separatorColor = [ThemeManager shareManager].themeLineColor;
    [self.tableView registerClass:[PersonInfoNormalCell class] forCellReuseIdentifier:cellID];
    [self.tableView registerClass:[AboutTopCell class] forCellReuseIdentifier:topCellID];
//    self.tableView.tableFooterView = self.footerView;
}
 
- (void)initData{
    self.titleArray = [NSMutableArray arrayWithObjects:@"",@"免责声明",nil];//0
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 183;
    }
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AboutTopCell *cell = [tableView dequeueReusableCellWithIdentifier:topCellID];
        if (!cell) {
            cell = [[AboutTopCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:topCellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        PersonInfoNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[PersonInfoNormalCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title = self.titleArray[indexPath.row];
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
    }else if (indexPath.row == 1){
        NSLog(@"免责声明");
        ZYDisclaimerVC *vc = [[ZYDisclaimerVC alloc] init];
        [self pushVc:vc];
    }
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
