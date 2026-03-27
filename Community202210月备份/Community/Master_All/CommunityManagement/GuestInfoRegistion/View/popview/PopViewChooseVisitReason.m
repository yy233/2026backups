//
//  PopViewChooseVisitReason.m
//  Community
// 拜访事由
//  Created by 余莹 on 2020/12/4.
//

#import "PopViewChooseVisitReason.h"

#define Popview_Tag_VisitReason  300
 
@implementation PopViewChooseVisitReason
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
#pragma mark == 重写
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    VisitReasonModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(basePopViewTag:OfSubTableViewTouchWithIndexPath:)]) {
        [self dismissThePopView];
        [self.delegate basePopViewTag:Popview_Tag_VisitReason  OfSubTableViewTouchWithIndexPath:indexPath];//Tag_SubPopView_VisitReason
    }
}
@end
