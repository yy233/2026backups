//
//  ChooseYearPopView.m
//  Community
//
//  Created by 余莹 on 2022/5/9.
//

#import "ChooseYearPopView.h"

@implementation ChooseYearPopView




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text =  [TextShowWithModelStr textShowWithModelStr: self.dataSource[indexPath.row]];
    if (indexPath.row != self.chooseSpotIndex ) {
        cell.textLabel.textColor =   [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.4];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    }else{
        cell.textLabel.textColor =   [ThemeManager shareManager].mainTextColor;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
    }
    
    return cell;
}

@end
