//
//  IssueAddPhoneTableViewController.h
//  Community
//
//  Created by 余莹 on 2021/1/20.
//。商铺类型的房屋选择列表

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssueAddPhotoBaseTableViewController : BaseTableViewController_DW
@property (nonatomic,strong) NSArray *sectionTitleArr;
@property (nonatomic,strong) NSArray *sectionDetailTitleArr;
//商铺的三组图 存储img用
@property (nonatomic,strong) NSMutableArray *sectionOneImgArr;
@property (nonatomic,strong) NSMutableArray *sectionTwoImgArr;
@property (nonatomic,strong) NSMutableArray *sectionThrImgArr;
//
@end

NS_ASSUME_NONNULL_END
