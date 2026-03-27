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


typedef void(^BaseListArrBlock)(NSArray * _Nullable listArrOfBlock);
typedef void(^BaseListArrAndSuccessBoolBlock)(NSArray * _Nullable listArrOfBlock,BOOL succes);
typedef void(^BaseDicBlock)(NSDictionary * _Nullable dicOfBlock);
typedef void(^BaseDicAndSuccessBoolBlock)(NSDictionary * _Nonnull dicOfBlock,BOOL succes);



NS_ASSUME_NONNULL_BEGIN


@interface BaseDataViewModel : NSObject
//- (instancetype)initwithPageZoreBegin;
@property (nonatomic,strong) NSMutableDictionary *thisParms;
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




/**
 
 BaseListArrBlock block = list;
 if (isNotNil(responsObject)) {
     if (Y_IS_Success) {
         block(Y_ResponsObject_dataArr);
     }else{
         block(@[]);
     }
 }else{
     block(@[]);
 }
 
 BaseListArrAndSuccessBoolBlock block = listBlock;
 if (isNotNil(responsObject)) {
     if (Y_IS_Success) {
         block(Y_ResponsObject_dataArr,YES);
     }else{
         block(@[],NO);
         Y_SVP_SHOW_ERR_MESSAGE
     }
 }else{
     block(@[],NO);
     Y_SVP_SHOW_ERR_DESCRIPTION
 }
}];
 
 BaseDicAndSuccessBoolBlock block = dicBlock;
 if (isNotNil(responsObject)) {
     if (Y_IS_Success) {
         NSDictionary *dic = Y_ResponsObject_dataDic;
         block(dic,YES);
     }else{
         block(@{},NO);
         Y_SVP_SHOW_ERR_MESSAGE
     }
 }else{
     block(@{},NO);
     Y_SVP_SHOW_ERR_DESCRIPTION
 }
}];
 */
@end

NS_ASSUME_NONNULL_END
