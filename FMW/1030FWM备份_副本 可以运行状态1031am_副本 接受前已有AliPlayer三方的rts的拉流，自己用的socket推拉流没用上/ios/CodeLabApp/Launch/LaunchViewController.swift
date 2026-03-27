//
//  LaunchViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/26.
//

import Foundation
import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var skipBtn: UIButton!
    fileprivate var countdown = 3
    fileprivate var timer: Timer?
    
    var skipTapHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.every(1) {[weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.countdown -= 1
            if strongSelf.countdown == 0 {
                strongSelf.skipBtnTap(0)
            }
            strongSelf.skipBtn.setTitle("跳过(\(strongSelf.countdown))", for: .normal)
        }
    }
    
    @IBAction func skipBtnTap(_ sender: Any) {
        timer?.invalidate()
        timer = nil
        skipTapHandler?()
    }
}
