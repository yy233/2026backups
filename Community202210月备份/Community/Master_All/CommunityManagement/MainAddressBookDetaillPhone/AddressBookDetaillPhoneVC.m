//
//  AddressBookDetaillPhoneVC.m
//  Community
//
//  Created by 余莹 on 2020/11/27.
//

#import "AddressBookDetaillPhoneVC.h"

@interface AddressBookDetaillPhoneVC ()

@end

@implementation AddressBookDetaillPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _model.department;
}

- (void)initData{
    [MainAddressBookViewModel getAddressBookDetailPhoneArrWithDepartmentId:_model.ID detailPhoneblock:^(NSMutableArray * arr) {
        NSMutableArray *arrOfThisDepartmentPhoneList =   [NSMutableArray arrayWithArray:[MainCenterCollectionViewAddressBookCellModel mj_objectArrayWithKeyValuesArray:arr]];
        self.dataSourceArr = arrOfThisDepartmentPhoneList;
        [self.tableView reloadData];
    }];
}
#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    MainCenterCollectionViewAddressBookCellModel *model = self.dataSourceArr[indexPath.row];
    cell.textLabel.text = model.person;
    cell.detailTextLabel.text = model.phone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MainCenterCollectionViewAddressBookCellModel *model = self.dataSourceArr[indexPath.row];
    [self callPhoneWithStr:model.phone];//
}
- (void)callPhoneWithStr:(NSString *)phoneStr{
    NSMutableString *callStr=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneStr];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr] options:@{} completionHandler:nil];

    /**
     NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneStr];
     UIWebView * callWebview = [[UIWebView alloc] init];
     [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
     [self.view addSubview:callWebview];
     */
    
}
@end
