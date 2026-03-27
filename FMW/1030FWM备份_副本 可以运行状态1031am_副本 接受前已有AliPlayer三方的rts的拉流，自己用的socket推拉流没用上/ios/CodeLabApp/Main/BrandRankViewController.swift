//
//  BrandRankViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/12.
//

import Foundation
import UIKit
import BasicKit
import BasicUIKit

final class BrandRankViewController: TableViewController {
    override func viewDidLoad() {
        showRefreshHeader = false
        showLoadMoreFooter = false
        super.viewDidLoad()
        customBar.isHidden = false
        customBackBtn.isHidden = false
        customBarTitleLabel.isHidden = false
        customBarTitleLabel.text = "热度排行"
        customBar.backgroundColor = .clear
        
        if let tableView = tableView {
            tableView.backgroundColor = .clear
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
            tableView.register(cellWithClass: RankTopCell.self)
            tableView.register(cellWithClass: RankCell.self)
            
            let headerImageView = UIImageView().then {
                $0.image = UIImage(named: "lab_login_background")
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                view.insertSubview($0, belowSubview: customBar)
                view.insertSubview($0, belowSubview: tableView)
                $0.snp.makeConstraints { make in
                    make.left.top.right.equalToSuperview()
                    make.height.equalTo(UIManager.shared.screenWidth*367.0/375.0)
                }
            }
            
            let _ = LinearGradientView().then {
                $0.startPoint = CGPoint(x: 0, y: 0)
                $0.endPoint = CGPoint(x: 0, y: 1)
                $0.colors = [color(255, 255, 255), color(254, 254, 254)]
                view.insertSubview($0, belowSubview: headerImageView)
                $0.snp.makeConstraints { make in
                    make.top.equalTo(headerImageView.snp.bottom).offset(-20)
                    make.left.right.bottom.equalTo(UIEdgeInsets.zero)
                }
            }
            
            let segmentView = UIView().then {
                $0.backgroundColor = color(246, 246, 246)
                $0.layer.cornerRadius = 16.5
                $0.layer.masksToBounds = true
                $0.layer.borderColor = UIColor.white.cgColor
                $0.layer.borderWidth = 1.0
                view.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.width.equalTo(243)
                    make.height.equalTo(33)
                    make.centerX.equalToSuperview()
                    make.top.equalTo(customBar.snp.bottom).offset(12)
                }
            }
            
            tableView.snp.makeConstraints({ make in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(segmentView.snp.bottom).offset(16)
            })
            
            let segmentSelectIndicator = UIView().then {
                $0.backgroundColor = .white
                $0.layer.cornerRadius = 16.5
                segmentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.top.bottom.equalToSuperview()
                    make.width.equalTo(56)
                }
            }
            
            let dayBtn = UIButton()
            let weekBtn = UIButton()
            let yearBtn = UIButton()
            let totalBtn = UIButton()
            
            dayBtn.do {
                $0.setTitle("日榜", for: .normal)
                $0.setTitleColor(color(0, 0, 0, 0.4), for: .normal)
                $0.setTitleColor(.black, for: .selected)
                $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 12)
                $0.addAction(UIAction() {_ in
                    yearBtn.isSelected = false
                    dayBtn.isSelected = true
                    weekBtn.isSelected = false
                    totalBtn.isSelected = false
                    
                    segmentSelectIndicator.snp.remakeConstraints { make in
                        make.left.right.equalTo(dayBtn)
                        make.top.bottom.equalToSuperview()
                    }
                    
                    UIView.animate(withDuration: 0.25) {
                        segmentSelectIndicator.superview?.layoutIfNeeded()
                    }
                }, for: .touchUpInside)
                segmentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.top.bottom.equalToSuperview()
                    make.width.equalTo(56)
                }
            }
            
            weekBtn.do {
                $0.setTitle("周榜", for: .normal)
                $0.setTitleColor(color(0, 0, 0, 0.4), for: .normal)
                $0.setTitleColor(.black, for: .selected)
                $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 12)
                $0.addAction(UIAction() {_ in
                    yearBtn.isSelected = false
                    dayBtn.isSelected = false
                    weekBtn.isSelected = true
                    totalBtn.isSelected = false
                    
                    segmentSelectIndicator.snp.remakeConstraints { make in
                        make.left.right.equalTo(weekBtn)
                        make.top.bottom.equalToSuperview()
                    }
                    
                    UIView.animate(withDuration: 0.25) {
                        segmentSelectIndicator.superview?.layoutIfNeeded()
                    }
                }, for: .touchUpInside)
                segmentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.equalTo(dayBtn.snp.right)
                    make.top.bottom.equalToSuperview()
                    make.width.equalTo(56)
                }
            }
            
            totalBtn.do {
                $0.setTitle("总榜", for: .normal)
                $0.setTitleColor(color(0, 0, 0, 0.4), for: .normal)
                $0.setTitleColor(.black, for: .selected)
                $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 12)
                $0.addAction(UIAction() {_ in
                    yearBtn.isSelected = false
                    dayBtn.isSelected = false
                    weekBtn.isSelected = false
                    totalBtn.isSelected = true
                    
                    segmentSelectIndicator.snp.remakeConstraints { make in
                        make.left.right.equalTo(totalBtn)
                        make.top.bottom.equalToSuperview()
                    }
                    
                    UIView.animate(withDuration: 0.25) {
                        segmentSelectIndicator.superview?.layoutIfNeeded()
                    }
                }, for: .touchUpInside)
                segmentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.right.top.bottom.equalToSuperview()
                    make.width.equalTo(56)
                }
            }
            
            yearBtn.do {
                $0.setTitle("2023", for: .normal)
                $0.setImage(UIImage(named: "lab_main_brand_rank_year"), for: .normal)
                $0.setTitleColor(color(0, 0, 0, 0.4), for: .normal)
                $0.setTitleColor(.black, for: .selected)
                $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 12)
                $0.imageEdgeInsets =  UIEdgeInsets(top: 0, left: 29, bottom: 0, right: -29)
                $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
                $0.addAction(UIAction() {_ in
                    yearBtn.isSelected = true
                    dayBtn.isSelected = false
                    weekBtn.isSelected = false
                    totalBtn.isSelected = false
                    
                    segmentSelectIndicator.snp.remakeConstraints { make in
                        make.left.right.equalTo(yearBtn)
                        make.top.bottom.equalToSuperview()
                    }
                    
                    UIView.animate(withDuration: 0.25) {
                        segmentSelectIndicator.superview?.layoutIfNeeded()
                    }
                }, for: .touchUpInside)
                segmentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    make.left.equalTo(weekBtn.snp.right)
                    make.right.equalTo(totalBtn.snp.left)
                }
            }
        }
    }
    
    //MARK: - Cell
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 10 + 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 185 : 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withClass: RankTopCell.self)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = .clear
            cell.iconView1.image = UIImage(named: "ge_icon_brand_rank_avatar_1")
            cell.titleLabel1.text = "AUTK"
            cell.descLabel1.setTitle(" 3380", for: .normal)
            cell.scoreLabel1.text = "89%"
            cell.scoreLabel1.textColor = color(255, 38, 111)
            cell.scoreImageView1.image = UIImage(named: "lab_main_brand_rank_percent_up")
            cell.iconView2.image = UIImage(named: "ge_icon_brand_rank_avatar_2")
            cell.titleLabel2.text = "AUTK"
            cell.descLabel2.setTitle(" 3380", for: .normal)
            cell.scoreLabel2.text = "89%"
            cell.scoreLabel2.textColor = color(58, 230, 93)
            cell.scoreImageView2.image = UIImage(named: "lab_main_brand_rank_percent_down")
            cell.iconView3.image = UIImage(named: "ge_icon_brand_rank_avatar_2")
            cell.titleLabel3.text = "AUTK"
            cell.descLabel3.setTitle(" 3380", for: .normal)
            cell.scoreLabel3.text = "89%"
            cell.scoreLabel3.textColor = color(58, 230, 93)
            cell.scoreImageView3.image = UIImage(named: "lab_main_brand_rank_percent_down")
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withClass: RankCell.self)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .clear
        cell.titleLabel.text = "\(indexPath.section + 3)"
        cell.avatarView.image = UIImage(named: "ge_icon_brand_rank_avatar_\(indexPath.section%7 + 1)")
        cell.nameLabel.text = "CAMPIE"
        cell.scoreLabel1.setTitle(" 2744", for: .normal)
        cell.scoreImageView.image = indexPath.section%2 == 0 ? UIImage(named: "lab_main_brand_rank_percent_up") : UIImage(named: "lab_main_brand_rank_percent_down")
        cell.scoreLabel2.text = "45%"
        cell.scoreLabel2.textColor = indexPath.section%2 == 0 ? color(255, 38, 111) : color(58, 230, 93)
        cell.lineView.isHidden = indexPath.section == 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        UIManager.push(to: BrandDetailViewController())
    }
    
    fileprivate class RankTopCell: UITableViewCell {
        lazy var backView1 = UIImageView().then {
            $0.image = UIImage(named: "lab_main_user_rank_top_1")
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(88)
                make.height.equalTo(97)
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
            }
        }
        
        lazy var iconView1 = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(72)
                make.centerX.equalTo(backView1)
                make.centerY.equalTo(backView1).offset(2)
            }
        }
        
        lazy var titleLabel1 = UILabel().then {
            $0.font = .semiboldPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView1)
                make.width.lessThanOrEqualTo(100)
                make.height.equalTo(20)
                make.top.equalTo(backView1.snp.bottom).offset(4)
            }
        }
        
        lazy var descLabel1 = UIButton().then {
            $0.setImage(UIImage(named: "lab_main_brand_rank_score"), for: .normal)
            $0.setTitleColor(color(255, 38, 111), for: .normal)
            $0.titleLabel?.font = .gothamBoldFont(ofSize: 14)
            $0.contentEdgeInsets = .zero
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView1)
                make.top.equalTo(titleLabel1.snp.bottom).offset(4)
                make.height.equalTo(18)
                make.width.lessThanOrEqualTo(100)
            }
        }
        
        lazy var scoreLabel1 = UILabel().then {
            $0.font = .mediumPingFangSCFont(ofSize: 10)
            $0.textAlignment = .right
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView1)
                make.width.lessThanOrEqualTo(100)
                make.height.equalTo(14)
                make.top.equalTo(descLabel1.snp.bottom)
            }
        }
        
        lazy var scoreImageView1 = UIImageView().then {
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(scoreLabel1.snp.right).offset(2)
                make.centerY.equalTo(scoreLabel1)
                make.width.height.equalTo(8)
            }
        }
        
        lazy var backView2 = UIImageView().then {
            $0.image = UIImage(named: "lab_main_user_rank_top_2")
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(80)
                make.height.equalTo(89)
                make.left.equalTo(30)
                make.top.equalTo(20)
            }
        }
        
        lazy var iconView2 = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(64)
                make.centerX.equalTo(backView2)
                make.centerY.equalTo(backView2).offset(2)
            }
        }
        
        lazy var titleLabel2 = UILabel().then {
            $0.font = .semiboldPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView2)
                make.width.lessThanOrEqualTo(90)
                make.height.equalTo(20)
                make.top.equalTo(backView2.snp.bottom).offset(4)
            }
        }
        
        lazy var descLabel2 = UIButton().then {
            $0.setImage(UIImage(named: "lab_main_brand_rank_score"), for: .normal)
            $0.setTitleColor(color(255, 38, 111), for: .normal)
            $0.titleLabel?.font = .gothamBoldFont(ofSize: 14)
            $0.contentEdgeInsets = .zero
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView2)
                make.top.equalTo(titleLabel2.snp.bottom).offset(4)
                make.height.equalTo(18)
                make.width.lessThanOrEqualTo(100)
            }
        }
        
        lazy var scoreImageView2 = UIImageView().then {
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(scoreLabel2.snp.right).offset(2)
                make.centerY.equalTo(scoreLabel2)
                make.width.height.equalTo(8)
            }
        }
        
        lazy var scoreLabel2 = UILabel().then {
            $0.font = .mediumPingFangSCFont(ofSize: 10)
            $0.textAlignment = .right
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView2)
                make.width.lessThanOrEqualTo(100)
                make.height.equalTo(14)
                make.top.equalTo(descLabel2.snp.bottom)
            }
        }
        
        lazy var backView3 = UIImageView().then {
            $0.image = UIImage(named: "lab_main_user_rank_top_3")
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(80)
                make.height.equalTo(89)
                make.right.equalTo(-30)
                make.top.equalTo(backView2)
            }
        }
        
        lazy var iconView3 = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(64)
                make.centerX.equalTo(backView3)
                make.centerY.equalTo(backView3).offset(2)
            }
        }
        
        lazy var titleLabel3 = UILabel().then {
            $0.font = .semiboldPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView3)
                make.width.lessThanOrEqualTo(100)
                make.height.equalTo(20)
                make.top.equalTo(backView3.snp.bottom).offset(4)
            }
        }
        
        lazy var descLabel3 = UIButton().then {
            $0.setImage(UIImage(named: "lab_main_brand_rank_score"), for: .normal)
            $0.setTitleColor(color(255, 38, 111), for: .normal)
            $0.titleLabel?.font = .gothamBoldFont(ofSize: 14)
            $0.contentEdgeInsets = .zero
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView3)
                make.top.equalTo(titleLabel3.snp.bottom).offset(4)
                make.height.equalTo(18)
                make.width.lessThanOrEqualTo(100)
            }
        }
        
        lazy var scoreImageView3 = UIImageView().then {
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(scoreLabel3.snp.right).offset(2)
                make.centerY.equalTo(scoreLabel3)
                make.width.height.equalTo(8)
            }
        }
        
        lazy var scoreLabel3 = UILabel().then {
            $0.font = .mediumPingFangSCFont(ofSize: 10)
            $0.textAlignment = .right
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerX.equalTo(backView3)
                make.width.lessThanOrEqualTo(100)
                make.height.equalTo(14)
                make.top.equalTo(descLabel3.snp.bottom)
            }
        }
    }
    
    fileprivate class RankCell: UITableViewCell {
        fileprivate lazy var titleLabel = UILabel().then {
            $0.font = .gothamBoldFont(ofSize: 14)
            $0.textColor = color(174, 181, 196)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.width.lessThanOrEqualTo(100)
                make.height.lessThanOrEqualTo(25)
                make.centerY.equalToSuperview()
            }
        }
        
        fileprivate lazy var avatarView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(48)
                make.left.equalTo(titleLabel.snp.right).offset(16)
                make.centerY.equalToSuperview()
            }
        }
        
        fileprivate lazy var nameLabel = UILabel().then {
            $0.font = .mediumPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(avatarView.snp.right).offset(12)
                make.right.lessThanOrEqualTo(-100)
                make.height.equalTo(20)
                make.centerY.equalToSuperview()
            }
        }
        
        fileprivate lazy var scoreLabel1 = UIButton().then {
            $0.setImage(UIImage(named: "lab_main_brand_rank_score"), for: .normal)
            $0.setTitleColor(color(255, 38, 111), for: .normal)
            $0.titleLabel?.font = .gothamBoldFont(ofSize: 14)
            $0.contentEdgeInsets = .zero
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.top.equalTo(18)
                make.height.equalTo(18)
                make.width.lessThanOrEqualTo(100)
            }
        }
        
        fileprivate lazy var scoreImageView = UIImageView().then {
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(-16)
                make.top.equalTo(scoreLabel1.snp.bottom).offset(3)
                make.width.height.equalTo(8)
            }
        }
        
        fileprivate lazy var scoreLabel2 = UILabel().then {
            $0.font = .mediumPingFangSCFont(ofSize: 10)
            $0.textAlignment = .right
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.right.equalTo(scoreImageView.snp.left).offset(-2)
                make.width.lessThanOrEqualTo(100)
                make.height.equalTo(14)
                make.centerY.equalTo(scoreImageView)
            }
        }
        
        fileprivate lazy var lineView = UIView().then {
            $0.backgroundColor = color(246, 246, 246)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
        }
    }
}
