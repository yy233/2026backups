//
//  ViewController.swift
//  RobotSweeper
//
//  Created by 美超刘 on 2017/5/10.
//  Copyright © 2017年 美超刘. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        launchAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        launchAnimation()
    }
    
    func launchAnimation(){
        
        let viewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateViewController(withIdentifier: "LaunchScreen")
        
        let launchView = viewController.view
        
        let mainWindow = UIApplication.shared.keyWindow
        
        launchView?.frame = UIApplication.shared.keyWindow!.frame
        
        mainWindow?.addSubview(launchView!)
        
        //        UIView.animate(withDuration: 1, animations: UIViewAnimationOptions.beginFromCurrentState, completion: )
        UIView.animate(withDuration: 3, animations: {
            launchView?.alpha = 0
        }, completion: {(finish:Bool) -> Void in
            
            launchView?.removeFromSuperview()
        })
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

