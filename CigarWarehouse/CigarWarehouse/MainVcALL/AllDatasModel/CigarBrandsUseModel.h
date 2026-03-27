//
//  CigarBrandsUseModel.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


#pragma mark =============================================细节属性

#pragma mark ================
@interface BaseSVModel : NSObject
@property (nonatomic,strong) NSString *s;
@property (nonatomic,assign) BOOL v;
@end

#pragma mark ================
@interface Pic : NSObject
@property (nonatomic,strong) NSString *s;
@property (nonatomic,assign) BOOL v;
@end

#pragma mark ================
@interface Icon : NSObject
@property (nonatomic,strong) NSString *s;
@property (nonatomic,assign) BOOL v;
@end

#pragma mark ================
@interface EngName : NSObject
@property (nonatomic,strong) NSString *s;
@property (nonatomic,assign) BOOL v;
@end


#pragma mark ================
@interface TimeDateInfoModel : NSObject
@property (nonatomic,strong) NSString *T;
@property (nonatomic,assign) BOOL v;
@end

#pragma mark =============================================品牌相关
@interface CigarBrandsUseModel : NSObject
@property (nonatomic,copy)   NSString     *Brand;//品牌名字
@property (nonatomic,assign) NSInteger    Id;
@property (nonatomic,assign) BOOL         IsCuba;
@property (nonatomic,strong) NSString    *Pos;
@property (nonatomic,strong) Icon         *Icon;
@property (nonatomic,strong) EngName      *EngName;
@end

#pragma mark ================
@interface BrandTypesModel : NSObject
@property (nonatomic,copy)   NSString     *Name;//品牌子级别型号名字
@property (nonatomic,assign) NSInteger    Id;
@property (nonatomic,assign) NSInteger    BrandId;
@property (nonatomic,strong) NSNumber     *BasePrice;
@property (nonatomic,strong) NSString    *Pos;
@property (nonatomic,strong) Pic          *Pic;
@property (nonatomic,strong) EngName      *EngName;
@end

#pragma mark ================
@interface BrandStockInFoModel : NSObject //品牌库存信息
@property (nonatomic,copy)   NSString     *BrandId;//品牌id
@property (nonatomic,assign) NSInteger    Id;
@property (nonatomic,strong) NSString    *Pos;
@property (nonatomic,copy)   NSString     *Code;//码
@property (nonatomic,copy)   NSString     *Pack;//盒/支
@property (nonatomic,copy)   NSString     *BuyFrom;//购买地
@property (nonatomic,copy)   NSString     *ProduceFrom;//产地
@property (nonatomic,assign) NSInteger    Pieces;//数量
@property (nonatomic,strong) NSNumber     *BuyPrice;//购买价格
@property (nonatomic,strong) BaseSVModel  *Owner;//拥有者
@property (nonatomic,strong) BaseSVModel  *Name;//名字
@property (nonatomic,strong) TimeDateInfoModel *InDate;//
@property (nonatomic,strong) TimeDateInfoModel *DoneDate;//
@property (nonatomic,strong) TimeDateInfoModel *UnPackDate;//拆包时间
//@property (nonatomic,assign) BOOL         tubos;//铝管
@property (nonatomic,assign) NSInteger         tubos;//铝管

@end

#pragma mark =============================================位置相关
@interface PlaceModel : NSObject
@property (nonatomic,copy)   NSString     *Place;//仓库名字
@property (nonatomic,assign) NSInteger    Id;
@end

#pragma mark ================
@interface CabinetModel : NSObject
@property (nonatomic,copy)   NSString     *Cabinet;//柜子名字
@property (nonatomic,assign) NSInteger    Id;
@property (nonatomic,assign) NSInteger    Pid;
@end

#pragma mark ================
@interface LevelModel : NSObject
@property (nonatomic,copy)   NSString     *Level;//柜子号数文本
@property (nonatomic,assign) NSInteger    Id;
@property (nonatomic,assign) NSInteger    Cid;
@end

#pragma mark ==============================================================================================================

#pragma mark ============================================= 品牌
@interface InsertBrandModel : NSObject
@property (nonatomic,copy)   NSString     *brand;
@property (nonatomic,copy)   NSString     *eng_name;
@property (nonatomic,copy)   NSString     *icon;
@property (nonatomic,assign) BOOL         is_cuba;
@property (nonatomic,strong) NSString    *Pos;
@end

@interface InsertBrandTypeModel : NSObject
@property (nonatomic,strong) NSNumber     *base_price;//价格
@property (nonatomic,assign) NSInteger    brand_id;
@property (nonatomic,copy)   NSString     *eng_name;
@property (nonatomic,copy)   NSString     *name;
@property (nonatomic,copy)   NSString     *pic;
@property (nonatomic,strong) NSString    *Pos;
@end

#pragma mark ============================================= 位置



#pragma mark =============================================入库创建存/出库下订单相关

@interface CreateOrdersModel : NSObject
@property (nonatomic,copy)   NSString     *buyer;
@property (nonatomic,copy)   NSString     *orderCode;
//@property (nonatomic,strong) NSNumber      *price;//价格
@property (nonatomic,assign) float      price;//价格
@property (nonatomic,assign) NSInteger    quantity;
@property (nonatomic,assign) NSInteger    stock_id;
@end


@interface InsertStockModel : NSObject
@property (nonatomic,assign) NSInteger    brand_id;
@property (nonatomic,assign) NSInteger    brand_type_id;
@property (nonatomic,copy)   NSString     *buy_from;
@property (nonatomic,strong) NSNumber     *buy_price;//价格
@property (nonatomic,assign) NSInteger    cigar_piece;//数量
@property (nonatomic,copy)   NSString     *code;
@property (nonatomic,copy)   NSString     *owner;
@property (nonatomic,copy)   NSString     *pack;
@property (nonatomic,copy)   NSString     *pos;
@property (nonatomic,copy)   NSString     *produce_from;
//@property (nonatomic,assign) BOOL         tubos;//铝管
@property (nonatomic,assign) NSInteger         tubos;//铝管

@property (nonatomic,copy)   NSString     *tubosInputStr;
@end





NS_ASSUME_NONNULL_END
