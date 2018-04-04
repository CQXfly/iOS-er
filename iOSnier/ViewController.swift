//
//  ViewController.swift
//  iOSnier
//
//  Created by fox on 2018/3/21.
//  Copyright © 2018年 fox. All rights reserved.
//

import UIKit
import RxSwift
import QXKit
class ViewController: UIViewController {
    
    @IBOutlet var tableview: UITableView!
    
    let viewModel = MainTableViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        tableview.register(MainTableCell.classForCoder(), forCellReuseIdentifier: "MaintableCell")
        
        viewModel.fetchData()
        
        
        bindUI()
    }
    
    func bindUI(){
        viewModel.topics.asObservable().skip(1).subscribe { (users) in
            self.tableview.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController : UITableViewDelegate {
//    let datas:[]
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = viewModel.topics.value[indexPath.row]
        
        
        
        let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.postID = topic.id
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190.0
    }
}

extension ViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.topics.value.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "MaintableCell") as! MainTableCell
        
        let topic = viewModel.topics.value[indexPath.row]
    
        cell.topic = topic
        
        let user = viewModel.getUserDetail(topic.posters.first!.user_id)

        cell.user = user
        
        return cell
    }
}

