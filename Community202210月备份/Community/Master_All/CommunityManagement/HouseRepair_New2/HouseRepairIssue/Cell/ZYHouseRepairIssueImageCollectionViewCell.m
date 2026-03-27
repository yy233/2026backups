//
//  ZYHouseRepairIssueImageCollectionViewCell.m
//  Community
//
//  Created by ZY on 2022/4/11.
//

#import "ZYHouseRepairIssueImageCollectionViewCell.h"

@implementation ZYHouseRepairIssueImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.deleteButton.hitTestEdgeInsets = UIEdgeInsetsMake(-6, -6, -6, -6);
}

@end
