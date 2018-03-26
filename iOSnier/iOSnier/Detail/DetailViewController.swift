//
//  DetailViewController.swift
//  iOSnier
//
//  Created by fox on 2018/3/22.
//  Copyright © 2018年 fox. All rights reserved.
//

import UIKit
import MarkdownView
import QXKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var mdHeight: NSLayoutConstraint!
    
    lazy var replyScrollerView:UIScrollView = {
        let v = UIScrollView()
        return v
    }()
    
    @IBOutlet weak var markdownView: MarkdownView!
    var viewModel:DetailViewModel!
    var postID:Int = 0 {
        didSet{
            let url = "http://iosre.com/t/\(postID).json?track_visit=true&forceLoad=true&_=\(Date.currentTimeStamp(.Long))"
            print(url)
            viewModel = DetailViewModel(url)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getDetailArtical()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        bindUI()
        markdownView.isScrollEnabled = false
        markdownView.onRendered = { [weak self] height in
            self?.mdHeight.constant = height
            self?.view.setNeedsLayout()
        }
    }
    
    private func bindUI(){
        viewModel.data.asObservable().skip(1).subscribe { (posts) in
            let cook = posts.event.element?.first?.cooked
            
            let tmp = cook?.addHttps()
            
            self.markdownView.load(markdown:tmp)
            
//            self.relpyViewChange()
        }
    }
    
//    private func relpyViewChange(_ []){
//        
//    }

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

extension String {
    
    /**
     根据 正则表达式 截取字符串
     
     - parameter regex: 正则表达式
     
     - returns: 字符串数组
     */
    public func matchesForRegex(regex: String) -> [String]? {
        http://
        do {
            
            let regularExpression = try NSRegularExpression(pattern: regex, options: [])
            let range = NSMakeRange(0, self.characters.count)
            let results = regularExpression.matches(in: self, options: [], range: range)
            let string = self as NSString
            return results.map { string.substring(with: $0.range)}
        } catch {
            return nil
        }
    }
    
    public func addHttps()->String{
        do {
            let regex = "<img\\b(?=\\s)(?=(?:[^>=]|='[^']*'|=\"[^\"]*\"|=[^'\"][^\\s>]*)*?\\ssrc=['\"]([^\"]*)['\"]?)(?:[^>=]|='[^']*'|=\"[^\"]*\"|=[^'\"\\s]*)*\"\\s?\\/?>"
            let regularExpression = try NSRegularExpression(pattern: regex, options: [])
            let range = NSMakeRange(0, self.count)
            var results = regularExpression.matches(in: self, options: [], range: range).map { (r) -> NSRange in
                return r.range
            }
            let string = self as NSString
            if(results.count<=0){
                return self
            }
            //添加头部
            let first = NSMakeRange(0, (results.first?.location)!)
            results.insert(first, at: 0)
            
            let lastlocation = (results.last?.location)! + 1 + (results.last?.length)!
            let last = NSMakeRange(lastlocation, string.length - lastlocation)
            results.append(last)
            
            return results.reduce("") { (sum,range ) -> String in
                var res = string.substring(with:range)
                if(res.hasPrefix("<img src=\"//")){
                    let tmp = res.components(separatedBy: "<img src=\"")
                    let tmpS = "http:"+tmp.last!
                    res = "<img src=\"" + tmpS
                }
                return sum + res
            }
        } catch {
            return self
        }
    }
}
