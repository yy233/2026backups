//
//  MyHouseListVcChangeHouseView.m
//  Community
//
//  Created by 余莹 on 2021/8/5.
//

#import "MyHouseListVcChangeHouseView.h"
#import "MyHouseChangeHouseViewSubTableViewCell.h"
#define  MyHouseChangeHouseViewSubTableViewCell_Identifier    @"MyHouseChangeHouseViewSubTableViewCell"
#import "MyHouseCerEdHouseModel.h"
@implementation MyHouseListVcChangeHouseView
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyHouseChangeHouseViewSubTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:MyHouseChangeHouseViewSubTableViewCell_Identifier];
    if (!cell) {
        cell = [[MyHouseChangeHouseViewSubTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyHouseChangeHouseViewSubTableViewCell_Identifier];
    }
    cell.chooseBtn.selected = [self.chooseTypeSaveArr[indexPath.row] integerValue];
    if (self.selfType == MyHouseListChangeShowHouseList_Type_House) {
        //我的房屋 总的房间house列表数据
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.showDataArr[indexPath.row]];
        MyHouseRelationMeAllTypeHouseModel *model = [MyHouseRelationMeAllTypeHouseModel mj_objectWithKeyValues:dic];
        
        cell.titleL.text =  [TextShowWithModelStr textShowWithModelStr:model.communityText];
        cell.bottomL.text =  [TextShowWithModelStr textShowWithModelStr:model.houseSite];
        [cell.typeBtn newAnBtnWithTextStr:[TextShowWithModelStr textShowWithModelStr:model.relationText]];
        switch (model.relation) {
            case 7://租客 PersonRelatio_Num_Zuke
            {
                [cell.typeBtn newAnBtnWithLayerCorNerNum:8 withLayerLineWidth:0.5 withLayerLineColor:Y_ColorWith16FromRGB(0x8BE195)];
                [cell.typeBtn newAnBtnWithTextColor:Y_ColorWith16FromRGB(0x8BE195)];
            }
                break;
                
            default:
            {
                [cell.typeBtn newAnBtnWithLayerCorNerNum:8 withLayerLineWidth:0.5 withLayerLineColor:Y_ColorWith16FromRGB(0xFFA82B)];
                [cell.typeBtn newAnBtnWithTextColor:Y_ColorWith16FromRGB(0xFFA82B)];
            }
                break;
        }
     
    }
    return cell;
}
@end
