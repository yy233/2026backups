//
//  CertificationVC.m
//  Community
//
//  Created by 刘久炼 on 2021/2/27.
//

#import "CertificationVC.h"
#import "LoginPasswordSetVC.h"
#import "PayPasswordSetVC.h"
#import "PhoneChangeFirstStepVC.h"
#import "AccountCancelVC.h"


#import "PersonInfoNormalCell.h"

@interface CertificationVC ()

@property(nonatomic, strong) NSMutableArray *titleArray;

@end

static NSString *const normalCellID = @"PersonInfoNormalCell";

@implementation CertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self setupNavigationBarWhiteStyle];
    
    [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

- (void)initView{
    self.title = @"未来物服资质";
//    self.tableView.backgroundColor = Color_245Gray;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [ThemeManager shareManager].themeLineColor;
    [self.tableView registerClass:[PersonInfoNormalCell class] forCellReuseIdentifier:normalCellID];
//    self.tableView.tableFooterView = self.footerView;
}
- (void)initData{
    self.titleArray = [NSMutableArray arrayWithObjects:@"营业执照",@"食品经营许可证",@"互联网药品信息服务资格证",@"网络食品交易第三方平台提供者备案号",@"广播电视节目制作经营许可证",@"电信与信息服务业务经营许可证",nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonInfoNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellID];
    if (!cell) {
        cell = [[PersonInfoNormalCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:normalCellID];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title = self.titleArray[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {

    }else if (indexPath.row == 1){
        

    }else if (indexPath.row == 2){
        

    }else if (indexPath.row == 3){

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
