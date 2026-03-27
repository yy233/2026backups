//
//  Model.swift
//  CodeLabApp
//
//  Created by Sera on 2023/10/16.
//

import Foundation
import BasicUIKit

struct GoodsCategoryItem: Codable {
    var id: String = ""
    var name: String = ""
    var list: [GoodsGroupItem]?
    
    enum CodingKeys: String, CodingKey {
        case id = "goodsCategoryId"
        case name
        case list
    }
}

struct GoodsGroupItem: Codable {
    var id: String = ""
    var name: String = ""
    var list: [GoodsTypeItem]?
    
    enum CodingKeys: String, CodingKey {
        case id = "goodsGroupId"
        case name
        case list
    }
}

struct GoodsTypeItem: Codable {
    var id: String = ""
    var name: String = ""
    var icon: GoodsItem.MediaCover?
    
    enum CodingKeys: String, CodingKey {
        case id = "goodsTypeId"
        case name
        case icon
    }
}

class GoodsItem: Codable, IdentifierElement {
    var id: String = ""
    var name: String = ""
    var cover: MediaCover?
    var desc: String?
    var goodsNum: String?
    var images: [MediaCover]?
    var size: [GoodsSize]?
    var price: Double?
    var inventory: Int64?
    var guarantees: [SaleService]?
    var afterSales: [SaleService]?
    var modelImages: [MediaCover]?
    var sizeShowImage: MediaCover?
    var bord: BordItem?
    var isMark: Bool?
    
    var uniqueIdentifier: String { id }
    
    enum CodingKeys: String, CodingKey {
        case id = "goodsId"
        case name
        case cover
        case desc
        case goodsNum = "no"
        case images
        case size
        case price
        case inventory
        case guarantees = "guaranteeService"
        case afterSales = "afterSalesService"
        case modelImages = "modelShowImages"
        case sizeShowImage = "sizeCompareImage"
        case bord
        case isMark = "mark"
    }
    
    struct MediaCover: Codable {
        var guid: String = ""
        var wt: Double?
        var ht: Double?
    }
    
    struct GoodsSize: Codable {
        var type: String = ""
        var price: Double?
    }
    
    struct SaleService: Codable {
        var title: String = ""
        var desc: String?
    }
    
    struct BordItem: Codable {
        var id: String = ""
        var name: String?
        var icon: MediaCover?
        
        enum CodingKeys: String, CodingKey {
            case id = "bordId"
            case name
            case icon
        }
    }
}

class AddressItem: Codable, IdentifierElement {
    var id: String = ""
    var name: String = ""
    var mobile: String = ""
    var city: String = ""
    var address: String = ""
    var isDefault: Int?
    var uniqueIdentifier: String { id }
    
    enum CodingKeys: String, CodingKey {
        case id = "addressId"
        case name
        case mobile = "phone"
        case city = "administrative"
        case address = "detailAddress"
        case isDefault = "setDefault"
    }
}

class GoodsOrderItem: Codable, IdentifierElement {
    var id: String = ""
    var status: Status = .receivedFinish
    var goodsInfo: GoodsItem?
    var addressInfo: AddressItem?
    var chooseSize: String?
    var goodsNum: Int64?
    var createTimeMills: TimeInterval?
    var payAllMoney: Double?
    var expressNo: String?
    var uniqueIdentifier: String { id }
    
    enum CodingKeys: String, CodingKey {
        case id = "orderId"
        case status
        case goodsInfo
        case addressInfo
        case chooseSize
        case goodsNum
        case createTimeMills
        case payAllMoney
        case expressNo
    }
    
    enum Status: Int32, Codable {
        case needPay = 1
        case payWaitSend = 2
        case cancel = 4
        case cancelForTimeOut = 3
        case sendWaitReceive = 5
        case receivedFinish = 6
        case saleServiceHanding = 7
        case saleServiceFinish = 8
    }
    
    var statusTitle: String {
        switch status {
        case .needPay:
            return "等待付款"
        case .cancel, .cancelForTimeOut:
            return "订单已取消"
        case .payWaitSend:
            return "待发货"
        case .sendWaitReceive:
            return "已发货"
        case .receivedFinish:
            return "已完成"
        case .saleServiceHanding:
            return "退货中"
        case .saleServiceFinish:
            return "已完成退货"
        }
    }
    
    var statusDesc: String {
        switch status {
        case .needPay:
            return "在十分钟内付款，否则系统将取消订单"
        case .cancel:
            return "主动取消订单"
        case .cancelForTimeOut:
            return "超时未付款，系统已取消订单"
        case .payWaitSend:
            return "7天内发货"
        case .sendWaitReceive:
            return expressNo.nonnull
        case .receivedFinish:
            return expressNo.nonnull
        case .saleServiceHanding:
            return "卖家收到货物确认无误后退款，款项原路退回"
        case .saleServiceFinish:
            return "款项已原路退回"
        }
    }
}
