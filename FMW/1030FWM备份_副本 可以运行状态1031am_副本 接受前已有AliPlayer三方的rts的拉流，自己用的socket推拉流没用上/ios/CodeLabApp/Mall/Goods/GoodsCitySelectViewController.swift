//
//  GoodsCitySelectViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/10/16.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit

final class GoodsCitySelectViewController: UIViewController {
    
    var didSelectHandler: ((String) -> Void)?
    
    private let contentView = UIView()
    fileprivate let cityPicker = UIPickerView()
    var cityList = [Province]()
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.location(in: view).y < contentView.frame.minY {
            dismissBtnTap()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        contentView.do {
            $0.backgroundColor = .white
            $0.layer.shadowOffset = CGSize(width: 0, height: -2)
            $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
            $0.layer.shadowRadius = 4
            $0.layer.shadowOpacity = 1
            view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(280)
            }
        }
        
        let cancelBtn = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
            $0.setTitle("取消", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 18)
            $0.addTarget(self, action: #selector(dismissBtnTap), for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(25)
                make.width.lessThanOrEqualTo(60)
                make.height.equalTo(23)
                make.top.equalTo(15)
            }
        }
        
        let _ = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
            $0.setTitle("确定", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 18)
            $0.addAction(UIAction() {[unowned self] _ in
                let text1 = cityList[safe: cityPicker.selectedRow(inComponent: 0)]?.provinceName
                let text2 = cityList[safe: cityPicker.selectedRow(inComponent: 0)]?.list?[safe: cityPicker.selectedRow(inComponent: 1)]?.cityName
                let text3 = cityList[safe: cityPicker.selectedRow(inComponent: 0)]?.list?[safe: cityPicker.selectedRow(inComponent: 1)]?.list?[safe: cityPicker.selectedRow(inComponent: 2)]?.name

                didSelectHandler?("\(text1.nonnull)\(text2.nonnull)\(text3.nonnull)")
                dismiss(animated: true)
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-25)
                make.width.lessThanOrEqualTo(60)
                make.height.equalTo(23)
                make.top.equalTo(15)
            }
        }
        
        cityPicker.do {
            $0.backgroundColor = .white
            $0.delegate = self
            $0.dataSource = self
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(cancelBtn.snp.bottom)
            }
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "City", ofType: "json").nonnull)),
               let list = try? JSONDecoder().decode([Province].self, from: data) {
                self.cityList.append(contentsOf: list)
            }
            
            DispatchQueue.main.async {
                self.cityPicker.reloadAllComponents()
            }
        }
    }
    
    @objc fileprivate func dismissBtnTap() {
        dismiss(animated: true)
    }
}

extension GoodsCitySelectViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return cityList.isEmpty ? 0 : 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return cityList.count
        }
        if component == 1 {
            return cityList[safe: pickerView.selectedRow(inComponent: 0)]?.list?.count ?? 0
        }
        return cityList[safe: pickerView.selectedRow(inComponent: 0)]?.list?[safe: pickerView.selectedRow(inComponent: 1)]?.list?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.selectRow(0, inComponent: 1, animated: false)
            pickerView.selectRow(0, inComponent: 2, animated: false)
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
        } else if component == 1 {
            pickerView.selectRow(0, inComponent: 2, animated: false)
            pickerView.reloadComponent(2)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return UILabel().then {
            if component == 0 {
                $0.text = cityList[safe: row]?.provinceName
            } else if component == 1 {
                $0.text = cityList[safe: pickerView.selectedRow(inComponent: 0)]?.list?[safe: row]?.cityName
            } else {
                $0.text = cityList[safe: pickerView.selectedRow(inComponent: 0)]?.list?[safe: pickerView.selectedRow(inComponent: 1)]?.list?[safe: row]?.name
            }
            $0.textColor = .black
            $0.font = .regularPingFangSCFont(ofSize: 16)
            $0.textAlignment = .center
        }
    }
}

extension GoodsCitySelectViewController {
    struct Province: Codable {
        var provinceName = ""
        var list: [City]?
        
        enum CodingKeys: String, CodingKey {
            case provinceName
            case list = "cities"
        }
    }
    
    struct City: Codable {
        var cityName = ""
        var list: [Area]?
        
        enum CodingKeys: String, CodingKey {
            case cityName
            case list = "counties"
        }
    }
    
    struct Area: Codable {
        var name = ""
        
        enum CodingKeys: String, CodingKey {
            case name = "countyName"
        }
    }
}
