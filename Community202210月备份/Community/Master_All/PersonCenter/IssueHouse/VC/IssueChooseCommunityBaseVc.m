//
//  IssueChooseCommunityBaseVc.m
//  Community
//
//  Created by 余莹 on 2021/1/23.
//

#import "IssueChooseCommunityBaseVc.h"

@interface IssueChooseCommunityBaseVc ()

@end

@implementation IssueChooseCommunityBaseVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommunityModel *model = self.dataSourceArr[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(issueChooseCommunityVcGetModel:withStr:)]) {
        [_delegate issueChooseCommunityVcGetModel:model withStr:model.name];
    }
    [self popVC];
}

@end
