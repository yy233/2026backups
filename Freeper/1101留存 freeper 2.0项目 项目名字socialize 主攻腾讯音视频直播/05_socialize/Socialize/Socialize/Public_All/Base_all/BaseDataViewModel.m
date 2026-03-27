//
//  BaseViewModel.m
//  EShops
//
//  Created by 余莹 on 2022/2/14.
//

#import "BaseDataViewModel.h"

@implementation BaseDataViewModel


//- (instancetype)initwithPageZoreBegin
//{
//    self = [super init];
//    if (self) {
//        self.pageNum = 0;
//    }
//    return self;
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageNum = 1;
        self.thisParms = @{
            @"count":@(Y_PAGE_SIZE_10),
            @"page":@(self.pageNum)
        }.mutableCopy;
    }
    return self;
}

//arr
- (void)getDataListOnePage{
}
- (void)getDataListNextPage{
}
- (void)getDataListAll{
    
}
- (void)getNetDataWithPageNum:(NSInteger)willGetPageNum withBlock:(BaseListArrAndSuccessBoolBlock)block{
    
}
//dic
- (void)getDataDic{

    /**
     //______dic
     //s
     self.dataOfDic = getdic;
     self.thisIsSuccessBool = YES;
     self.showMsgStr = @"得到数据";
     //f
     self.dataOfDic = @{};
     self.thisIsSuccessBool = NO;
     self.showMsgStr = @"获取失败";
     */
}
//baseModel
- (void)getDataModel{
    
}


- (NSMutableArray *)saveOldArrWithWillChangBaseArr{
    if (!_saveOldArrWithWillChangBaseArr) {
        _saveOldArrWithWillChangBaseArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _saveOldArrWithWillChangBaseArr;
}

- (NSMutableDictionary *)thisParms{
    if (!_thisParms) {
        _thisParms = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    return _thisParms;
}
@end
