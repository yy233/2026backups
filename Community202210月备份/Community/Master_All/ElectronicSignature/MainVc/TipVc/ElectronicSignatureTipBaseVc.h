//
//  ElectronicSignatureTipBaseVc.h
//  Community
//
//  Created by 余莹 on 2021/1/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ElectronicSignatureTipBaseVc : ZYBaseViewController
@property (nonatomic,strong) UIImageView *backImgV;
@property (nonatomic,strong) ElectronicSignatureBaseFooterView *footerView;
@property (nonatomic,strong) UIImageView *topTitleImgV;
@property (nonatomic,strong) UITableView *tableView;
//
@property (nonatomic,strong) NSMutableArray *cellTitleTextArr;
@property (nonatomic,strong) NSMutableArray *cellContentTextArr;
@end

NS_ASSUME_NONNULL_END
