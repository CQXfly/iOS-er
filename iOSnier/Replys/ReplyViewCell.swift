//
//  ReplyViewCell.swift
//  iOSnier
//
//  Created by fox on 2018/3/26.
//  Copyright © 2018年 fox. All rights reserved.
//

import UIKit
class ReplyViewCell: UITableViewCell {
    
    var line : UIView = UIView()
    
    var vm: ReplyCellViewModel? {
        didSet {
            contentView.removeAllSubviews()
            contentView.addSubview(vm!.markDownV)
            vm!.markDownV.linkTapHandler = { [unowned self] link in
                
                let l = link.hasSuffix(".dylib") || link.hasSuffix(".ipa") || link.hasSuffix(".zip") ||
                    link.hasSuffix(".pdf")
                
                if l {
                    UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
                    
                } else {
                    let sf = SFHandoffSafariViewController(url: URL(string: link)!,entersReaderIfAvailable:true)
                    self.topMostController()?.present(sf, animated: true, completion: nil)
                }
            }
            
            markdown = vm!.markDownV

        }
    }
    
    var markdown: MarkDownView? {
        didSet {
            markdown?.snp.makeConstraints{
                $0.edges.equalTo(0)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.line.snp.makeConstraints{
            $0.height.equalTo(1)
            $0.bottom.equalTo(self.contentView.snp.bottom)
            $0.leading.equalTo(0)
            $0.trailing.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
}


public extension UIView {
    
    ///----------------------
    /// MARK: viewControllers
    ///----------------------
    
    /**
     Returns the UIViewController object that manages the receiver.
     */
    public func viewController()->UIViewController? {
        
        var nextResponder: UIResponder? = self
        
        repeat {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            
        } while nextResponder != nil
        
        return nil
    }
    
    /**
     Returns the topMost UIViewController object in hierarchy.
     */
    public func topMostController()->UIViewController? {
        
        var controllersHierarchy = [UIViewController]()
        
        if var topController = window?.rootViewController {
            controllersHierarchy.append(topController)
            
            while topController.presentedViewController != nil {
                
                topController = topController.presentedViewController!
                
                controllersHierarchy.append(topController)
            }
            
            var matchController :UIResponder? = viewController()
            
            while matchController != nil && controllersHierarchy.contains(matchController as! UIViewController) == false {
                
                repeat {
                    matchController = matchController?.next
                    
                } while matchController != nil && matchController is UIViewController == false
            }
            
            return matchController as? UIViewController
            
        } else {
            return viewController()
        }
    }
}
