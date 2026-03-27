//
//  ParkingVcLate.m
//  Community
//
//  Created by 余莹 on 2022/5/6.
//

#import "ParkingVcLate.h"
#import "ZYParkingMonthCardVc.h"

@interface ParkingVcLate ()

@end

@implementation ParkingVcLate

- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark==
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            NSLog(@"月卡");
            ZYParkingMonthCardVc *vc = [[ZYParkingMonthCardVc alloc] init];
            [self pushVc:vc];
        }
            break;
        case 1:
        {
            NSLog(@"缴费记录");
         
        }
            break;

        default:
            break;
    }
}
@end
