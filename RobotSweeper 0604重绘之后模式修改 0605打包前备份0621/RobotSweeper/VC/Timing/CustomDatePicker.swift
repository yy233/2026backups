//
//  CustomDataPicker.swift
//  RobotSweeper
//
//  Created by 美超刘 on 2017/5/18.
//  Copyright © 2017年 美超刘. All rights reserved.
//

import UIKit

class CustomDatePicker: UIView,UIPickerViewDataSource,UIPickerViewDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var hourPicker : UIPickerView!
    var minutePicker : UIPickerView!
    var hourArr : Array<String> = Array()
    var minuteArr : Array<String> = Array()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for h in 0 ..< 24{
            
            hourArr.append(h < 10 ? "0\(h)" : "\(h)")
        }
        for m in 0 ..< 60{
            
            minuteArr.append(m < 10 ? "0\(m)" : "\(m)")
        }
        
        hourPicker = UIPickerView(frame: CGRect(x: _originX(69), y: _originY(40), width: _width(50), height: _height(140)))
        hourPicker.delegate = self
        hourPicker.dataSource = self
        self.addSubview(hourPicker)
        
        let hourLabel = UILabel(frame: CGRect(x: hourPicker.rightX(), y: hourPicker.centerY() - _originY(5) , width: _width(20), height: _height(20)))
        hourLabel.backgroundColor = UIColor.clear
        if #available(iOS 8.2, *) {
            hourLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        } else {
            // Fallback on earlier versions
            hourLabel.font = UIFont.systemFont(ofSize: 15)
        }
        hourLabel.text = "时"
        hourLabel.textColor = HexColor(hexValue: 0xffffff, alpha: 1.0)
        self.addSubview(hourLabel)
        
        minutePicker = UIPickerView(frame: CGRect(x: SCREEN_WIDTH - _width(69) - _width(50), y: _originY(35), width: _width(50), height: _height(140)))
        minutePicker.delegate = self
        minutePicker.dataSource = self
        self.addSubview(minutePicker)
        
        let minuteLabel = UILabel(frame: CGRect(x: minutePicker.rightX(), y: hourPicker.centerY() - _originY(5) , width: _width(20), height: _height(20)))
        minuteLabel.backgroundColor = UIColor.clear
        if #available(iOS 8.2, *) {
            minuteLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        } else {
            // Fallback on earlier versions
            minuteLabel.font = UIFont.systemFont(ofSize: 15)
        }
        minuteLabel.text = "分"
        minuteLabel.textColor = HexColor(hexValue: 0xffffff, alpha: 1.0)
        self.addSubview(minuteLabel)
        
        let sepLabel = UILabel(frame: CGRect(x: 0, y: 0, width: _width(20), height: _height(20)))
        sepLabel.center = CGPoint(x: SCREEN_WIDTH/2, y: hourPicker.centerY())
        sepLabel.textColor = HexColor(hexValue: 0xffffff, alpha: 1.0)
        if #available(iOS 8.2, *) {
            sepLabel.font = UIFont.systemFont(ofSize: 28, weight: UIFontWeightLight)
        } else {
            // Fallback on earlier versions
            sepLabel.font = UIFont.systemFont(ofSize: 28)
        }
        sepLabel.textAlignment = .center
        sepLabel.text = ":"
        self.addSubview(sepLabel)
        
        hourPicker.selectRow(12, inComponent: 0, animated: false)
        minutePicker.selectRow(30, inComponent: 0, animated: false)

    }
    
    func pickerViewDidLoad(pickerView: UIPickerView){
        
        if pickerView == hourPicker{
            let max = hourArr.count * 3
            let base = max/2 - (max/2)%hourArr.count
            hourPicker.selectRow(hourPicker.selectedRow(inComponent: 0) % hourArr.count + base, inComponent: 0, animated: false)
            
        }else{
            
            let max = minuteArr.count * 3
            
            let base = max/2 - (max/2)%minuteArr.count
            minutePicker.selectRow(minutePicker.selectedRow(inComponent: 0) % minuteArr.count + base, inComponent: 0, animated: false)
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerView == hourPicker ?  hourArr.count * 3 : minuteArr.count * 3
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerView == hourPicker ?  hourArr[row % hourArr.count] : minuteArr[row % minuteArr.count]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        for line in pickerView.subviews{
            if line.frame.size.height < 1{
                line.backgroundColor = UIColor.clear
            }
        }
        
        var textLabel = view as? UILabel
        if textLabel == nil{
            textLabel = UILabel()
            textLabel!.textColor = HexColor(hexValue: 0xffffff, alpha: 1)
            if #available(iOS 8.2, *) {
                textLabel?.font = UIFont.systemFont(ofSize: _height(40), weight: UIFontWeightLight)
            } else {
                // Fallback on earlier versions
                textLabel?.font = UIFont.systemFont(ofSize: _height(40))
            }

            
            textLabel?.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        }
        
        return textLabel!
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return _height(60)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickerViewDidLoad(pickerView: pickerView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
