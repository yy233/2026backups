//
//  AccompanyPersonListModel.h
//  Community
//
//  Created by 余莹 on 2020/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ListArrBlock)(NSArray *);
@interface AccompanyPersonListModel : NSObject
+ (void)getAccompayPersonInitListWithBlock:(ListArrBlock)listArrBlock;
+ (void)getAccompayPersonUpdatMoreListWithBlock:(ListArrBlock)listArrBlock nowPageNum:(NSInteger)pageNum;
@end

NS_ASSUME_NONNULL_END
