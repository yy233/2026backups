//
//  ZYHouseRepairIssueEditCell.h
//  Community
//
//  Created by ZY on 2022/4/11.
//

#import <UIKit/UIKit.h>
#import "ZYHouseRepairIssueUploadModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYHouseRepairIssueEditCellDelegate <NSObject>

// 报事业主
- (void)ownerViewEvent;

// 工单类型
- (void)orderViewEvent;

// 报事位置
- (void)addressViewEvent;

// 语音
- (void)recordButtonEvent;

// 添加照片
- (void)addPhotos;

// 选择照片
- (void)imageViewTapWithIndex:(NSInteger)index;

// 删除照片
- (void)deletePhotoWithIndex:(NSInteger)index;

@end

@interface ZYHouseRepairIssueEditCell : UITableViewCell

@property (nonatomic, strong) ZYHouseRepairIssueUploadModel *model;

@property (nonatomic, strong) NSArray *imagesArray;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, weak) id<ZYHouseRepairIssueEditCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
