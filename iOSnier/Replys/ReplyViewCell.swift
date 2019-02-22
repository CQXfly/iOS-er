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
            line.removeAllSubviews()
            setupUI()
            self.line.addSubview(vm!.markDownV)
            
            self.avatar.kf.setImage(with: URL(string: vm!.avatar), placeholder: nil, options: [], progressBlock: nil) { (a, b, c, d) in
                self.avatar.image = a
            }
            
            self.usernameLabel.text = vm!.username
            
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
                $0.bottom.equalTo(self.line.snp.bottom)
                $0.leading.equalToSuperview()
                $0.trailing.equalToSuperview()
                $0.top.equalTo(self.avatar.snp.bottom).offset(8)
            }
        }
    }
    
    var avatar:UIImageView
    
    var usernameLabel : UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.avatar = UIImageView()
        self.usernameLabel = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    private func setupUI(){
        self.avatar = UIImageView()
        self.usernameLabel = UILabel()
        self.line.backgroundColor = UIColor.lightGray
        self.line.layer.cornerRadius = 4;
        contentView.addSubview(self.line)
        self.line.snp.makeConstraints{
            $0.top.equalTo(self.contentView.snp.top).offset(10);
            $0.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }
        
        
        self.line.addSubview(self.avatar)
        self.avatar.snp.makeConstraints{
            $0.leading.equalTo(8)
            $0.top.equalTo(8)
            $0.width.equalTo(32)
            $0.height.equalTo(32)
        }
        
        
        self.line.addSubview(self.usernameLabel)
        self.usernameLabel.font = UIFont.systemFont(ofSize: 16)
        self.usernameLabel.snp.makeConstraints{
            $0.leading.equalTo(self.avatar.snp.trailing).offset(8)
            $0.top.equalTo(self.avatar)
            $0.trailing.equalToSuperview().offset(-8)
            $0.height.equalTo(self.avatar.snp.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.avatar = UIImageView()
        self.usernameLabel = UILabel()
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
