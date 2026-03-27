//
//  MyOrderDetailVcTopBtnsTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/7.
//

#import <UIKit/UIKit.h>
#import "MyOrderDetailVcBaseTextTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@protocol MyOrderDetailVcTopBtnsTableViewCellDelegate <NSObject>
- (void)topBtncellType:(MyOrderListCell_Type)type subBtnTouchBtnIndex:(NSInteger)index;
@end

@interface MyOrderDetailVcTopBtnsTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UIView *btnsBackV;
- (void)fillBtnsWithArr:(NSMutableArray *)btnTitleArr andImgNameArr:(NSMutableArray *)imgNameArr whitType:(MyOrderListCell_Type)type;
@property (nonatomic,weak) id <MyOrderDetailVcTopBtnsTableViewCellDelegate> delegate; 
@end

NS_ASSUME_NONNULL_END
