//
//  MyRepairPageBaseListOfMsgAndImgsTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/4/11.
//

#import <UIKit/UIKit.h>
#import "MyRepairPageListUseModel.h"
#import "MyRepairShowDetailWorkOrderInfoModel.h"
NS_ASSUME_NONNULL_BEGIN
static NSString *MyRepairPageBaseListOfMsgAndImgsTableViewCell_I = @"MyRepairPageBaseListOfMsgAndImgsTableViewCell";

typedef void(^MsgAndImgsCellTouchOneImgBlock)(NSInteger indexx);

@interface MyRepairPageBaseListOfMsgAndImgsTableViewCell : BaseTableViewCell
@property (nonatomic,copy) MsgAndImgsCellTouchOneImgBlock msgAndImgsCellTouchOneImgBlock;
- (void)fillDataWithModel:(MyRepairPageListUseModel *)model;//列表页
- (void)fillDetailVcModel:(MyRepairShowDetailWorkOrderInfoModel *)model;//详情页工单信息的cell数据填充位置
@end

NS_ASSUME_NONNULL_END
