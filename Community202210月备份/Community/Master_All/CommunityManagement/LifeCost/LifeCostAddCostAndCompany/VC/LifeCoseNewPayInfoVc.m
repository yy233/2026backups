//
//  LifeCoseNewPayInfoVc.m
//  Community
//
//  Created by 余莹 on 2021/3/24.
//

#import "LifeCoseNewPayInfoVc.h"

@interface LifeCoseNewPayInfoVc ()

@end

@implementation LifeCoseNewPayInfoVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
 
- (void)initData{
    Y_SVP_DISMISS
    NSString *userName = [TextShowWithModelStr textShowWithModelStr:self.thisCostDetailmodel.familyName];
    NSString *userNo = [NSString stringWithFormat:@"%ld",(long)self.thisCostDetailmodel.familyId];
    NSString *userUnit = [TextShowWithModelStr textShowWithModelStr:self.thisCostDetailmodel.companyName];
    NSString *address = [TextShowWithModelStr textShowWithModelStr:self.thisCostDetailmodel.address];
    self.sectionOneContentArr  = [[NSMutableArray alloc]initWithObjects:userName,userNo,userUnit,address, nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    });
}
@end
