//
//  PensionMapAllViewSubMapV.h
//  Community
//
//  Created by 余莹 on 2021/12/1.
//

#import <UIKit/UIKit.h>

 

NS_ASSUME_NONNULL_BEGIN

//@protocol PensionMapAllViewSubChooseOneAddressMapViewDeleaget <NSObject>
//- (void)chooseNewAddressWithInfo:(id)addressInfo;
//@end

//@interface PensionMapAllViewSubChooseOneAddressMapV : UIView <MKMapViewDelegate>
//@property (nonatomic,weak) id <PensionMapAllViewSubChooseOneAddressMapViewDeleaget> delegate;

typedef void(^SubMapMoveChangedBlock)(void);

@interface PensionMapAllViewSubChooseOneAddressMapV : UIView  

@property (nonatomic,strong) NSString *saveShooseAddressLatStr;
@property (nonatomic,strong) NSString *saveShooseAddressLongStr;
@property (nonatomic,strong) NSString *saveShooseAddressTextStr;

- (void)setlocateToLatitude:(CGFloat)lati longitude:(CGFloat)longi;//初始状态的展示位置
- (void)searchAddressWithSearchText:(NSString *)searchText;//文本搜地址位置列表 得其某个位置
@property (nonatomic,copy)  SubMapMoveChangedBlock mapMoveChangedBlock;
@end

NS_ASSUME_NONNULL_END
