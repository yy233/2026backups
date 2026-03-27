//
//  ZhiBoListViewModel.m
//  Socialize
//
//  Created by 余莹 on 2023/5/26.
//

#import "ZhiBoListViewModel.h"


///
static NSString *const kZhiBoListData_sub_Url = @"/activity/getActivityList";

static NSString *const kMyZhiBoListData_sub_Url = @"/activity/auth/getUserActivityList";//isMyZhiBoType




@implementation ZhiBoListViewModel

- (NSMutableArray *)saveOldArrChangeNewArr{
    if (!_saveOldArrChangeNewArr) {
        _saveOldArrChangeNewArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _saveOldArrChangeNewArr;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageNum = 1;
    }
    return self;
}

//---
//将模型数组按照时间进行排序
//- (NSArray *)sortedArrayUsingComparatorByPaymentTimeWithDataArr:(NSArray <ZhiBoShowInfoModel*> *)dataArr{
//
//    NSArray *sortArray = [dataArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//
//        ZhiBoShowInfoModel *model1 = obj1;
//
//        ZhiBoShowInfoModel *model2 = obj2;
//
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//
//        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
//
//        NSDate *date1= [dateFormatter dateFromString:model1.startDatetime];
//
//        NSDate *date2= [dateFormatter dateFromString:model2.startDatetime];
//
//        if (date1 == [date1 earlierDate: date2]) {
//
//            return NSOrderedAscending;//升序
//
//        }else if (date1 == [date1 laterDate: date2]) {
//
//            return NSOrderedDescending;//降序
//
//        }else{
//
//            return NSOrderedSame;//相等
//
//        }
//
//    }];
//
//    return sortArray;
//
//}


//---NSSortDescriptor 排序
- (NSArray *)changeDataShunXuWithArr:(NSArray <ZhiBoShowInfoModel*> *)modelArr{
    
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc]initWithKey:@"startDatetime" ascending:YES];//ascending:YES 代表升序 如果为NO 代表降序
//    NSMutableArray *sortDescriptors=[[NSMutableArray alloc]initWithObjects:&sorter count:1];
    NSMutableArray *sortDescriptors = @[sorter].mutableCopy;
    NSArray *sortArray=[modelArr sortedArrayUsingDescriptors:sortDescriptors];
    
    NSLog (@"sortArray - %@",sortArray);
    
    return sortArray;
}
- (void)getDataListOnePage{
    self.pageNum = 1;
    [self getNetDataWithPageNum:1 withBlock:^(NSArray * _Nonnull arr, BOOL success) {
        //data
        if (success) {
            
            if(arr.count>0){//只做数据处理 0时page不做处理
                self.saveOldArrChangeNewArr = [[NSMutableArray alloc]initWithArray: [ZhiBoShowInfoModel mj_objectArrayWithKeyValuesArray:arr]];
//                self.dataOfArr = [[NSArray alloc]initWithArray:self.saveOldArrChangeNewArr];
                NSArray *moedelArr = [[NSArray alloc]initWithArray:self.saveOldArrChangeNewArr];
                self.dataOfArr = [self changeDataShunXuWithArr:moedelArr];

                //
                self.showMsgStr = Y_LocaleTypeFile_NSLocalString(@"获取成功");
                self.pageNum += 1;
            }else{
                self.saveOldArrChangeNewArr = [[NSMutableArray alloc]initWithCapacity:0];
//                self.dataOfArr = [[NSArray alloc]initWithArray:self.saveOldArrChangeNewArr];
                NSArray *moedelArr = [[NSArray alloc]initWithArray:self.saveOldArrChangeNewArr];
                self.dataOfArr = [self changeDataShunXuWithArr:moedelArr];
                self.showMsgStr = Y_LocaleTypeFile_NSLocalString(@"暂无数据");
                
            }
            
        }else{
            self.showMsgStr = Y_LocaleTypeFile_NSLocalString(@"获取失败");
        }
        //showtype
        self.thisIsSuccessBool = success;
    }];
    
}
- (void)getDataListNextPage{
    
    [self getNetDataWithPageNum:self.pageNum withBlock:^(NSArray * _Nonnull arr, BOOL success) {
        //data
        if (success) {
            //mj_objectArrayWithKeyValuesArray
            [self.saveOldArrChangeNewArr  addObjectsFromArray: [ZhiBoShowInfoModel mj_objectArrayWithKeyValuesArray:arr]];
//            self.dataOfArr = [[NSArray alloc]initWithArray:self.saveOldArrChangeNewArr];
            NSArray *moedelArr = [[NSArray alloc]initWithArray:self.saveOldArrChangeNewArr];
            self.dataOfArr = [self changeDataShunXuWithArr:moedelArr];
            //
            if(arr.count>0){
                self.showMsgStr = Y_LocaleTypeFile_NSLocalString(@"加载成功");
                self.pageNum += 1;
                NSLog(@"新的一页 有数据 pageNum增加 用于下次数据直接使用");
            }else{
                self.showMsgStr = Y_LocaleTypeFile_NSLocalString(@"暂无更多数据");
                NSLog(@"新的一页 没有数据 pageNum不增加");
            }
        }else{
            self.showMsgStr = Y_LocaleTypeFile_NSLocalString(@"获取失败");
        }
        //showtype
        self.thisIsSuccessBool = success;
    }];
    
}

- (void)getNetDataWithPageNum:(NSInteger)willGetPageNum withBlock:(BaseListArrAndSuccessBoolBlock)block{

    [self.thisParms setValue:@(Y_PAGE_SIZE_10)   forKey:@"count"];
    [self.thisParms setValue:@(willGetPageNum)   forKey:@"page"];
    NSMutableDictionary *parms = self.thisParms;
    NSString * kZhiBoListData_AllUrl = Y_AllURL_Main(kZhiBoListData_sub_Url);
    [[Y_NetWorkBaseTool sharedTool]YYrequestALLURLPostNotMainQueue:kZhiBoListData_AllUrl withParams:parms finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success_status) {
                NSDictionary *dataDic = Y_ResponsObject_dataDic;
                NSMutableArray *getArrs =  ( [[dataDic allKeys] containsObject:data_records_Key] && isNotNil([dataDic objectForKey:data_records_Key]) ) ? [dataDic objectForKey:data_records_Key] : [NSMutableArray array];
                block(getArrs,YES);
                
            }else{
                block(@[],NO);
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_ERR_MESSAGE
                });
            }
        }else{
            block(@[],NO);
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_DESCRIPTION
            });
        }
    }];
    
    
    
}


@end

//
@implementation ZhiBoShowInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"description_D" : @"description",
             @"transHash_T":@"transHash",
             @"roomId":@"id"
    };
}


-(id)copyWithZone:(NSZone *)zone{
    id objCopy = [[[self class] allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value&&([value isKindOfClass:[NSMutableArray class]]||[value isKindOfClass:[NSArray class]])) {
            id valueCopy  = [[NSMutableArray alloc]initWithArray:value copyItems:YES];
            [objCopy setValue:valueCopy forKey:propertyName];
        }else if(value){
            [objCopy setValue:[value copy] forKey:propertyName];
        }
    }
    free(properties);
    return objCopy;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    id objCopy = [[[self class] allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value&&([value isKindOfClass:[NSMutableArray class]]||[value isKindOfClass:[NSArray class]])) {
            id valueCopy  = [[NSMutableArray alloc]initWithArray:value copyItems:YES];
            [objCopy setValue:valueCopy forKey:propertyName];
        }else if(value){
            [objCopy setValue:[value copy] forKey:propertyName];
        }
    }
    free(properties);
    return objCopy;
}

//- (void)encodeWithCoder:(nonnull NSCoder *)coder {
//    if (self = [super init])
//       {
//          self.title = [coder decodeObjectForKey:@"title"];
//          self.subTitle = [coder decodeObjectForKey:@"subTitle"];
//          self.detail = [coder decodeObjectForKey:@"detail"];
//          self.icon = [coder decodeObjectForKey:@"icon"];
//          self.cellHeigjt = [coder decodeFloatForKey:@"cellHeigjt"];
//          self.subModelArray = [coder decodeObjectForKey:@"subModelArray"];
//           self.subModel = [coder decodeObjectForKey:@"subModel"];
//        }
//       return self;
//}
//
//- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
//    [coder encodeObject:self.title forKey:@"title"];
//           [coder encodeObject:self.subTitle forKey:@"subTitle"];
//           [coder encodeObject:self.detail forKey:@"detail"];
//           [coder encodeObject:self.icon forKey:@"icon"];
//           [coder encodeFloat:self.cellHeigjt forKey:@"cellHeigjt"];
//           [coder encodeObject:self.subModelArray forKey:@"subModelArray"];
//          [coder encodeObject:self.subModel forKey:@"subModel"];
//     
//}

@end
