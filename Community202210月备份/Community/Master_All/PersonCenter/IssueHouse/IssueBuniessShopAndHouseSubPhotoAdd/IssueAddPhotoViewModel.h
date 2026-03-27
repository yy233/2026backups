//
//  IssueAddPhotoViewModel.h
//  Community
//
//  Created by 余莹 on 2021/2/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssueAddPhotoViewModel : NSObject

+ (void)issueAddBuniessPhotosWithHeadImgs:(NSMutableArray *)headImgs
                           withMiddleImgs:(NSMutableArray *)middeImgs
                            withOtherImgs:(NSMutableArray *)otherImgs
                                    block:(BaseDicAndSuccessBoolBlock)imgUrlBlock;
+ (void)issueAddHousePhotosWithAllImgs:(NSMutableArray *)allImgs
                                    block:(BaseListArrAndSuccessBoolBlock)imgUrlListBlock;


@end

NS_ASSUME_NONNULL_END
