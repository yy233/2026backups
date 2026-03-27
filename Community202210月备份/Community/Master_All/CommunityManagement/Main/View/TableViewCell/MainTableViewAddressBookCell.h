//
//  MainTableViewAddressBookCell.h
//  Community
//
//  Created by 余莹 on 2020/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AddressBookViewDelegate<NSObject>
- (void)addressBookViewCollectionCellDidSelectWithItem:(NSIndexPath *)indexPath;
@end
@interface MainTableViewAddressBookCell : UITableViewCell
@property (nonatomic,strong) NSMutableArray <MainCenterCollectionViewAddressBookCellModel *> *sourceArr;
@property (nonatomic,strong) id <AddressBookViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
