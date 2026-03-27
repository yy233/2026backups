//
//  ElectronicSignatureNomalTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/25.
//

#import <UIKit/UIKit.h>
 
#import "ElectronicSignatureNomalImgAndTextCellView.h"
#define ElectronicSignatureNomalImgAndTextCellView_Identifier                @"ElectronicSignatureNomalImgAndTextCellView"
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ElectronicSignatureVC_Cell_Type_Top,
} ElectronicSignatureVC_Cell_Type;


@interface ElectronicSignatureNomalInfoItemsTableViewCell : UITableViewCell
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UICollectionView *collectionView;
- (void)showCellWithType:(ElectronicSignatureVC_Cell_Type)type;
@end

NS_ASSUME_NONNULL_END
