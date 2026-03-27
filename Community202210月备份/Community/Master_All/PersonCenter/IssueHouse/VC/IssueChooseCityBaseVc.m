//
//  IssueChooseCityBaseVc.m
//  Community
//
//  Created by 余莹 on 2021/1/23.
//

#import "IssueChooseCityBaseVc.h"

@interface IssueChooseCityBaseVc ()

@end

@implementation IssueChooseCityBaseVc

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark === topCityTableViewCellBtnAction 热门城市model
-(void)topCityTableViewCellBtnAction:(UIButton *)sender{
    NSInteger indexNum = sender.tag-Main_SUB_CityChoose_TopCityItem_TAG;
    CityChooseModel *model = self.topSourceArr[indexNum];
    NSLog(@"topCityCellBtnAction === %ld,%@",(long)model.id,model.name);
    [self popWithModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //跳转到下一级别 换成返回上级+notice
    [self didBottomCellIndexPatch:indexPath];
}
- (void)didBottomCellIndexPatch:(NSIndexPath *)indexPath{
    CityChooseModel *model = [[CityChooseModel alloc]init];
    if (indexPath.section>0) {//非热门城市
        if (self.searchTextStr.length > 0) {
            NSArray *arrOfRowModel = [CityChooseModel mj_objectArrayWithKeyValuesArray:self.searchSourceArr];
            model = arrOfRowModel[indexPath.row];
            NSLog(@"search cell index  === %ld,%@",(long)model.id,model.name);
          
        }else{
            NSString *key = [NSString stringWithString:self.bottomListHeaderTitleSourceArr[indexPath.section-1]];
            //        NSArray *arrOfRow = [NSArray arrayWithArray:[self.bottomListSourceDic objectForKey:key]];
            NSArray *arrOfRowModel = [CityChooseModel mj_objectArrayWithKeyValuesArray:[self.bottomListSourceDic objectForKey:key]];
            model = arrOfRowModel[indexPath.row];
            NSLog(@"did BottomCellIndexPatch === %ld,%@",(long)model.id,model.name);
        }
    }
    [self popWithModel:model];
   
}
- (void)popWithModel:(CityChooseModel *)model{
    if (_delegate && [_delegate respondsToSelector:@selector(issueChooseCityVcGetModel:withStr:)]) {
        [_delegate issueChooseCityVcGetModel:model withStr:model.name];
    }
    [self popVC];
}
@end
