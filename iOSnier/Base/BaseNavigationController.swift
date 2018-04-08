//
//  BaseNavigationController.swift
//  iOSnier
//
//  Created by fox on 2018/4/4.
//  Copyright © 2018年 fox. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard self.viewControllers.count > 0 else {
            super.pushViewController(viewController, animated: animated)
            return;
        }
        viewController.hidesBottomBarWhenPushed = true;
        super.pushViewController(viewController, animated: animated)
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
