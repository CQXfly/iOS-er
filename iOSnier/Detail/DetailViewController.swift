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
import SafariServices

open class SFHandoffSafariViewController: SFSafariViewController {
    
    override public init(url URL: URL, entersReaderIfAvailable: Bool) {
        super.init(url: URL, entersReaderIfAvailable: entersReaderIfAvailable)
        if userActivity == nil && URL.scheme != nil {
            userActivity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
        }
        userActivity?.webpageURL = URL
        delegate = self
    }
    
    convenience public init(url URL: URL) {
        self.init(url: URL, entersReaderIfAvailable: false)
    }
}

extension SFHandoffSafariViewController: SFSafariViewControllerDelegate {
    
    open func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        if didLoadSuccessfully {
            controller.userActivity?.becomeCurrent()
        }
    }
    
    open func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.userActivity?.resignCurrent()
    }
    
}


class DetailViewController: UIViewController {
    
    @IBOutlet weak var mdHeight: NSLayoutConstraint!
    
    lazy var mdView:MarkDownView = {
        let v = MarkDownView()
        v.completionRender = { [unowned self ] height in
            self.mdView.snp.updateConstraints{
                $0.height.equalTo(height)
            }
        }
        
        v.linkTapHandler = { [unowned self] link in
            
            let l = link.hasSuffix(".dylib") || link.hasSuffix(".ipa") || link.hasSuffix(".zip")
            
            if l {
                UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
                
            } else {
                let sf = SFHandoffSafariViewController(url: URL(string: link)!,entersReaderIfAvailable:true)
                self.present(sf, animated: true, completion: nil)
            }
        }
        
        return v
    }()
    
    lazy var replyScrollerView:UIScrollView = {
        let v = UIScrollView()
        return v
    }()
    
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
        self.view.addSubview(replyScrollerView)
        self.replyScrollerView.addSubview(mdView)
        mdView.snp.makeConstraints{
            $0.top.equalTo(0)
            $0.leading.equalTo(0)
            $0.width.equalTo(self.view.snp.width)
            $0.trailing.equalTo(0)
            $0.height.equalTo(0)
            $0.bottom.equalToSuperview()
        }
        replyScrollerView.snp.makeConstraints{
            $0.edges.equalTo(UIEdgeInsetsMake(100, 0, 0, 0))
        }
        bindUI()

    }
    
    private func bindUI(){
        viewModel.data.asObservable().skip(1).subscribe { (posts) in
            let cook = posts.event.element?.first?.cooked
            
            let tmp = cook?.addHttps()
            
//            self.markdownView.load(markdown:tmp)
            
            
            self.mdView.url = cook!
            
            
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
