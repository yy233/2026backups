//
//  EquipmentManagementTableVc.m
//  Community
//
//  Created by 余莹 on 2021/5/18.
//

#import "EquipmentManagementTableVc.h"

@interface EquipmentManagementTableVc ()

@end

@implementation EquipmentManagementTableVc

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupsetupNavigationBarWithChatVcStyle];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" ];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"reuseIdentifier"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font  = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = Y_ColorWith16FromRGB(0x333333);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
        cell.detailTextLabel.textColor = Y_ColorWith16FromRGB(0x888888);
    }
    cell.textLabel.text = @"Android 设备";
    cell.detailTextLabel.text = @"2020-12-18 15:15";
    return cell;
}

@end
