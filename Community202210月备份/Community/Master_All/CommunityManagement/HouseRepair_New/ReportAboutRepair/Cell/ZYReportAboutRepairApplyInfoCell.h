//
//  ZYReportAboutRepairApplyInfoCell.h
//  Community
//
//  Created by ZY on 2022/3/7.
//

#import <UIKit/UIKit.h>
#import "ZYReportAboutRepairApplyUploadModel.h"

#define kZYReportAboutRepairApplyInfoCollectionViewCell_W (kScreenW-64)/2.0
#define kZYReportAboutRepairApplyInfoCollectionViewCell_H 50

NS_ASSUME_NONNULL_BEGIN

@protocol ZYReportAboutRepairApplyInfoCellDelegate <NSObject>

- (void)addressViewEvent;

- (void)matterButtonEvent;

- (void)repairButtonEvent;

- (void)collectionViewSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface ZYReportAboutRepairApplyInfoCell : UITableViewCell

@property (nonatomic, strong) ZYReportAboutRepairApplyUploadModel *model;

@property (nonatomic, strong) NSArray *dataArray;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *telTF;

@property (nonatomic, weak) id<ZYReportAboutRepairApplyInfoCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
