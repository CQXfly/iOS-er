//
//  ReplyViewController.swift
//  iOSnier
//
//  Created by fox on 2018/4/4.
//  Copyright © 2018年 fox. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {
    var vm:ReplyViewModel = ReplyViewModel()
    
    var posts:[Post]? {
        didSet {
            self.vm.cooks = posts!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ReplyViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.vm.viewmodels[indexPath.row].height + 20
    }
}
extension ReplyViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.viewmodels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyViewCell") as! ReplyViewCell
        cell.vm = self.vm.viewmodels[indexPath.row]
        return cell
        
        
        
    }
    
    
}
