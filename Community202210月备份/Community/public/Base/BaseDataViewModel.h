//
//  BaseDataViewModel.h
//  EShops
//
//  Created by 余莹 on 2022/2/14.
//

#import <Foundation/Foundation.h>

static NSString * _Nullable kViewModel_dataOfModel = @"dataOfModel";
static NSString * _Nullable kViewModel_dataOfDic = @"dataOfDic";
static NSString * _Nullable kViewModel_dataOfArr = @"dataOfArr";
static NSString * _Nullable kViewModel_showMsgStr = @"showMsgStr";
static NSString * _Nullable kViewModel_thisIsSuccessBool = @"thisIsSuccessBool";
NS_ASSUME_NONNULL_BEGIN

@interface BaseDataViewModel : NSObject
@property (strong,nonatomic) NSObject     *dataOfModel;
@property (strong,nonatomic) NSDictionary *dataOfDic;
@property (strong,nonatomic) NSArray      *dataOfArr;
@property (strong,nonatomic) NSString     *showMsgStr;
@property (nonatomic,assign) NSInteger    pageNum;
@property (nonatomic,assign) BOOL         thisIsSuccessBool;//本次失败成功bool
@property (nonatomic,strong) NSMutableArray *saveOldArrWithWillChangBaseArr;//做list时 累加arr时使用


- (void)getDataListOnePage;
- (void)getDataListNextPage;
- (void)getDataListAll;
- (void)getNetDataWithPageNum:(NSInteger)willGetPageNum withBlock:(BaseListArrAndSuccessBoolBlock)block;
//- (void)getDataDic;
- (void)getDataModel;
@end

NS_ASSUME_NONNULL_END
