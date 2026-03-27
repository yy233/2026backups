//
//  TimingVC.swift
//  RobotSweeper
//
//  Created by 美超刘 on 2017/5/17.
//  Copyright © 2017年 美超刘. All rights reserved.
//

import UIKit

class TimingVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var weekTableView : UITableView!
    let weekArr = ["周一","周二","周三","周四","周五","周六","周日"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "设置定时清扫"
       
        self.initNavgationBarItem()
        self.view.backgroundColor = HexColor(hexValue: 0xf5f5f5, alpha: 1.0)
        self.view.backgroundColor = UIColor.lightGray
        weekTableView = UITableView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), style: .grouped)
        weekTableView.backgroundColor = UIColor.clear
        weekTableView.isScrollEnabled = false
        weekTableView.delegate = self
        weekTableView.dataSource = self
        weekTableView.separatorColor = UIColor.clear
        weekTableView.register(WeekCell.classForCoder(), forCellReuseIdentifier: "cellI")
        self.view.addSubview(weekTableView)
        
        let pickerView = CustomDatePicker(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: _height(200)))
        weekTableView.tableHeaderView = pickerView
        
    }
    
    func initHeaderView(){
        
       
        
    }
    
    func initNavgationBarItem(){
        
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 00, y: 0, width: 40, height: 20)
        leftBtn.setTitle("取消", for: .normal)
        leftBtn.setTitleColor(UIColor.black, for: .normal)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        leftBtn.addTarget(self, action: #selector(leftBarItemAction), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        
        let rightBtn = UIButton(type: UIButtonType.custom)
        rightBtn.frame = CGRect(x: 00, y: 0, width: 40, height: 22)
        rightBtn.setTitle("保存", for: .normal)
        rightBtn.setTitleColor(UIColor.black, for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightBtn.addTarget(self, action: #selector(saveBarItemAction), for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }
    
    override func leftBarItemAction(){
        self.navigationController?.popViewController(animated: true)
    }

    func saveBarItemAction()  {
        //保存
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:=====tableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weekArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellI") as! WeekCell
        
        cell.weekLabel.text = weekArr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
         return _height(60)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! WeekCell
        cell.isSelect = !cell.isSelect
        
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class WeekCell : UITableViewCell{
    
    var weekLabel : UILabel!
    var selectImageView : UIImageView!
    
    
    var isSelect = false{
        didSet{
            if isSelect{
//                weekLabel.textColor = HexColor(hexValue: 0x, alpha: 1.0)
                selectImageView.image = SkinManager.skin_imageWithName(imageName: "xuanzhong")
            }else{
                weekLabel.textColor = UIColor.white
                selectImageView.image = SkinManager.skin_imageWithName(imageName: "Oval")
            }
        }
    }
 
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = HexColor(hexValue: 0x000000, alpha: 0.3)
        weekLabel = UILabel(frame: CGRect(x: _originX(25), y: _originY(20), width: _width(200), height: _height(20)))
        weekLabel.textColor = UIColor.white
        if #available(iOS 8.2, *) {
            weekLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightRegular)
        } else {
            // Fallback on earlier versions
            weekLabel.font = UIFont.systemFont(ofSize: 15)
        }
        self.contentView.addSubview(weekLabel)
    
        selectImageView = UIImageView(frame: CGRect(x: SCREEN_WIDTH - _width(45), y: _originY(21), width: _width(18), height: _width(18)))
        selectImageView.image = SkinManager.skin_imageWithName(imageName: "Oval")
        self.contentView.addSubview(selectImageView)
        
        let lineView = UIView(frame: CGRect(x: 0, y: _height(59), width: SCREEN_WIDTH, height: _height(1)))
        lineView.backgroundColor = HexColor(hexValue: 0x0ecff2, alpha: 0.6)
        self.contentView.addSubview(lineView)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
