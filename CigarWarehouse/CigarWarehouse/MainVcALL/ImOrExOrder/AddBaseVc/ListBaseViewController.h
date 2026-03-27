//
//  ListBaseViewController.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/20.
//

#import <UIKit/UIKit.h>
#import "ListBaseTableViewCell.h"
#define cell_tf_BaseTag (6000)

NS_ASSUME_NONNULL_BEGIN



@interface BaseOfTopBtnView : UIView
@property (nonatomic,strong) UIButton *showImgBtn;

@end

@interface BaseOfBottomBtnView : UIView
@property (nonatomic,strong) UIButton *footerB;

@end

@interface ListBaseViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) NSMutableArray *dataSourceTitleArr;
@property (nonatomic,strong) NSMutableArray *dataSourceSourceArr;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) BaseOfTopBtnView *topShowImgView;
@property (nonatomic,strong) BaseOfBottomBtnView *footerView;
- (void)iconImgTap;//照相图片触发
@end

NS_ASSUME_NONNULL_END
