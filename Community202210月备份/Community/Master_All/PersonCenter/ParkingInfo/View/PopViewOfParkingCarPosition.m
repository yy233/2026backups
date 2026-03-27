//
//  PopViewOfParkingCarPosition.m
//  Community
//
//  Created by 余莹 on 2021/8/27.
//

#import "PopViewOfParkingCarPosition.h"
#import "CarPositionModel.h"

@implementation PopViewOfParkingCarPosition

//                [CarPositionModel mj_objectArrayWithKeyValuesArray:]

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   return [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
   if (!cell) {
       cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
   }
   cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
   cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    CarPositionModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = [TextShowWithModelStr textShowWithModelStr:model.carPosition];
   return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   if ([self.delegate respondsToSelector:@selector(basePopViewTag:OfSubTableViewTouchWithIndexPath:)]) {
       [self dismissThePopView];
       [self.delegate basePopViewTag:0  OfSubTableViewTouchWithIndexPath:indexPath];
   }
}

@end
