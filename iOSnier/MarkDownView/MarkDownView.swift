//
//  MarkDownView.swift
//  iOSnier
//
//  Created by fox on 2018/3/31.
//  Copyright © 2018年 fox. All rights reserved.
//

import UIKit
import YYKit
import Kingfisher
class MarkDownView: UIView {
    
    private var doms:[MarkDownViewParserType]?
    
    var mdHeight:CGFloat = 0
    var completionRender:((CGFloat)->Void)?
    var linkTapHandler:((String)->Void)?
    var url : String? {
        didSet {
            self.doms = MarkDownParser(docs: url!).parser()
            setupUI()
            completionRender?(self.mdHeight)
        }
    }
    
    private func setupUI(){
        
        self.removeAllSubviews()
        
        var lastV : UIView = UIView()
        lastV.tag = 0
        for parser in self.doms! {
            switch parser {
                
            case .H1(let text):
                createH1Label(p: text, lastV: &lastV)
                continue
                
            case .H2(let text):
                createH2Label(p: text, lastV: &lastV)
                continue
                
            case .P(let text):
                createPLabel(p: text, lastV: &lastV)
                continue
                
            case .Img(let src, let width, let height):
                createImageView(text: src, width: width, height: height, lastV: &lastV)
                continue
                
            case .Emoji(let src):
                setEmojiView(text: src, lastV: &lastV)
                continue
            
                
            case .Text(let text):
                createPLabel(p: text, lastV: &lastV)
                continue
                
            case .A(let text,let link):
                setAlink(text: text,href:link , lastV: &lastV)
                continue
                
            case .Br(let text):
                createBrLabel(p: text, lastV: &lastV)
                continue
            case .Li(let text):
                createLiLabel(li: text, lastV: &lastV)
                continue
            case .Code(let text):
                createCode(code: text, lastV: &lastV)
                continue
            case .Strong(let text):
                createStrongView(strong: text, lastV: &lastV)
                continue
            case .Aside(let _):
                
                continue
            }
        }
    }
    
    private func setEmojiView(text:String,lastV:inout UIView) {
        if lastV.isKind(of: YYLabel.classForCoder()) {
            let lastVV = lastV as! YYLabel
            let attribute = lastVV.attributedText as! NSMutableAttributedString
            lastVV.tag = lastV.tag + 1
            let imgV = UIImageView()
            
            imgV.kf.setImage(with:ImageResource(downloadURL: URL(string: text)!) , placeholder: nil, options: [], progressBlock: nil, completionHandler: { (img, err, cache, url) in
                
                imgV.image = img
                
                let attacnAttr = NSMutableAttributedString.attachmentString(withContent: imgV.image, contentMode:UIViewContentMode.scaleAspectFit, attachmentSize: CGSize(width: 15, height: 15), alignTo: UIFont.systemFont(ofSize: 15), alignment: .center)
                
                attribute.append(attacnAttr)
               
                self.mdHeight -= (lastVV.textLayout?.textBoundingSize.height)!
                
                lastVV.attributedText = attribute
                lastVV.textLayout = self.getTextLayout(text: attribute)
                
                self.mdHeight += lastVV.textLayout!.textBoundingSize.height
                
                lastVV.snp.updateConstraints{
                    $0.height.equalTo(lastVV.textLayout!.textBoundingSize.height)
                }
                
            })
             lastV = lastVV
            
          
        }
    }
    
    private func setAlink(text:String,href:String,lastV:inout UIView){
        
        
        if(lastV.isKind(of: YYLabel.classForCoder())){
            let lastvv = lastV as! YYLabel
            _ = lastvv.text?.count
            let lastAttr : NSMutableAttributedString = lastvv.attributedText as! NSMutableAttributedString
            let range = NSMakeRange(0, text.count)
            let attr = NSMutableAttributedString(string: text)
            attr.setTextHighlight(range, color: UIColor.red, backgroundColor: UIColor.gray) { [unowned self] (view, str, range, rect) in
                print(text)
                self.linkTapHandler?(href)
            }
            attr.addAttributes(defaultAttribute(), range: range)
            lastAttr.append(attr)
            
            
             createLabelView(attribute: lastAttr, lastV: &lastV, append: true)
        } else {
            let attr = NSMutableAttributedString(string: text)
            attr.addAttributes(defaultAttribute(), range: NSMakeRange(0, text.count))
            attr.setTextHighlight(NSMakeRange(0, text.count), color: UIColor.red, backgroundColor: UIColor.gray) { [unowned self] (view, str, range, rect) in
                print(str)
                self.linkTapHandler?(href)
            }
            createLabelView(attribute: attr, lastV: &lastV, append: false)
        }
        
       
        
        
    }
    
    @discardableResult
    private func createStrongView(strong:String,lastV:inout UIView) -> YYLabel{
        
        if(lastV.isKind(of: YYLabel.classForCoder())){
            
            if(strong.count < 40 ){
                let lastVV = lastV as! YYLabel
                let mattr = lastVV.attributedText as! NSMutableAttributedString
                let attr = NSMutableAttributedString(string: strong)
                
                var at = defaultAttribute()
                at[NSAttributedStringKey.font] = UIFont.boldSystemFont(ofSize: 16)
                attr.addAttributes(at, range: NSMakeRange(0, strong.count))
                
                mattr.append(attr)
                
                return createLabelView(attribute: mattr, lastV: &lastV, append: true)
            } else {
                let attr = NSMutableAttributedString(string: strong)
                attr.addAttributes(defaultAttribute(), range: NSMakeRange(0, strong.count))
                return createLabelView(attribute: attr, lastV: &lastV, append: false)
            }
        } else {
            let attr = NSMutableAttributedString(string: strong)
            attr.addAttributes(defaultAttribute(), range: NSMakeRange(0, strong.count))
            return createLabelView(attribute: attr, lastV: &lastV, append: false)
        }
        
    }
    
    @discardableResult
    private func createCode(code:String,lastV:inout UIView) -> YYLabel{
        let attr = NSMutableAttributedString(string: code)
        attr.addAttributes(defaultAttribute(), range: NSMakeRange(0, code.count))
        var label : YYLabel
        
        if code.count < 40 {
            if(lastV.isKind(of: YYLabel.classForCoder())){
                
                let lastvv = lastV as! YYLabel
                let  a = lastvv.attributedText as! NSMutableAttributedString
                a.append(attr)
                label = createLabelView(attribute: a, lastV: &lastV, append: true)
            } else {
                label = createLabelView(attribute: attr, lastV: &lastV, append: false)
                
                label.textContainerInset = UIEdgeInsetsMake(10, 4, 4, 4)
                
                label.layer.cornerRadius = 6
                label.layer.masksToBounds = true
                label.layer.borderWidth = 1
                label.layer.borderColor = UIColor.purple.cgColor
                 mdHeight += 14
            }
            
        } else {
            label = createLabelView(attribute: attr, lastV: &lastV, append: false)
            
            label.textContainerInset = UIEdgeInsetsMake(10, 4, 4, 4)
            
            label.layer.cornerRadius = 6
            label.layer.masksToBounds = true
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.purple.cgColor
            mdHeight += 14
        }
        
        
        
        return label
    }
    
    @discardableResult
    private func createLiLabel(li:String,lastV:inout UIView)->YYLabel{
        
        let tmp = "•  " + li
        let attr = NSMutableAttributedString(string: tmp)
        var at = defaultAttribute()
        at[NSAttributedStringKey.font] = UIFont.boldSystemFont(ofSize: 16)
        attr.addAttributes(at, range: NSMakeRange(0, tmp.count))
        return createLabelView(attribute: attr, lastV: &lastV, append: false)
    }
    
    private func createPLabel(p:String,lastV:inout UIView){
        let attr = NSMutableAttributedString(string: p)
        attr.addAttributes(defaultAttribute(), range: NSMakeRange(0, p.count))
        createLabelView(attribute: attr, lastV: &lastV, append: false)
    }
    
    @discardableResult
    private func createBrLabel(p:String,lastV:inout UIView) -> YYLabel{
        let attr = NSMutableAttributedString(string: p)
        attr.addAttributes(defaultAttribute(), range: NSMakeRange(0, p.count))
        return createLabelView(attribute: attr, lastV: &lastV, append: false)
    }
    
    @discardableResult
    private func createH1Label(p:String,lastV:inout UIView)->YYLabel{
        let attr = NSMutableAttributedString(string: p)
        var at = defaultAttribute()
        at[NSAttributedStringKey.font] = UIFont.boldSystemFont(ofSize: 22)
        attr.addAttributes(at, range: NSMakeRange(0, p.count))
        return createLabelView(attribute: attr, lastV: &lastV, append: false)
    }
    
    @discardableResult
    private func createH2Label(p:String,lastV:inout UIView) -> YYLabel {
        let attr = NSMutableAttributedString(string: p)
        var at = defaultAttribute()
        at[NSAttributedStringKey.font] = UIFont.boldSystemFont(ofSize: 22)
        attr.addAttributes(at, range: NSMakeRange(0, p.count))
        return createLabelView(attribute: attr, lastV: &lastV, append: false)
    }
    
    @discardableResult
    private func createLabelView(attribute:NSMutableAttributedString,lastV:inout UIView,append:Bool)->YYLabel {
        
        var label : YYLabel
        
        if append {
            label = lastV as! YYLabel
            label.tag = lastV.tag + 1
            mdHeight -= (label.textLayout?.textBoundingSize.height)!
            
            label.attributedText = attribute
            label.textLayout = getTextLayout(text: attribute)
            
            mdHeight += label.textLayout!.textBoundingSize.height
            
            label.snp.updateConstraints{
                $0.height.equalTo(label.textLayout!.textBoundingSize.height)
            }
            
        } else {
            label = YYLabel()
            self.addSubview(label)
            label.tag = lastV.tag + 1
            let textLayout = getTextLayout(text: attribute)
            
            let height = textLayout.textBoundingSize.height
            
            label.attributedText = attribute
            label.textLayout = textLayout
            
            if lastV.tag == 0 {
                //第一个
                mdHeight += 12 + height
                label.snp.makeConstraints{
                    $0.top.equalTo(12)
                    $0.leading.equalTo(16)
                    $0.trailing.equalTo(-16)
                    $0.height.equalTo(height)
                }
            } else if lastV.tag == doms!.count - 1 {
                //最后一个布局
                mdHeight += 8 + height
                label.snp.makeConstraints{
                    $0.top.equalTo(lastV.snp.bottom).offset(8)
                    $0.leading.equalTo(lastV.snp.leading)
                    $0.trailing.equalTo(lastV.snp.trailing)
                    $0.height.equalTo(height)
                    $0.bottom.equalToSuperview()
                }
            } else {
                mdHeight += 8 + height
                label.snp.makeConstraints{
                    $0.top.equalTo(lastV.snp.bottom).offset(8)
                    $0.leading.equalTo(lastV.snp.leading)
                    $0.trailing.equalTo(lastV.snp.trailing)
                    $0.height.equalTo(height)
                }
            }
        }
        
        lastV = label
        
        return label
    }
    
    @discardableResult
    private func createImageView(text:String,width:CGFloat,height:CGFloat,lastV:inout UIView) -> UIImageView {
        
        let imgV = UIImageView()
        imgV.tag = lastV.tag + 1
        imgV.kf.setImage(with: ImageResource(downloadURL: URL(string: text)!), placeholder: nil, options: [], progressBlock: nil) { (img, err, cache, url) in
            
            imgV.image = img
        }
        addSubview(imgV)
        let height = 343 * height / width
        self.mdHeight += 10 + height
        if(lastV.tag == 0){
            imgV.snp.makeConstraints{
                $0.top.equalTo(10)
                $0.leading.equalTo(16)
                $0.trailing.equalTo(-16)
                $0.height.equalTo(height)
            }
        } else {
            imgV.snp.makeConstraints{
                $0.top.equalTo(lastV.snp.bottom).offset(10)
                $0.leading.equalTo(16)
                $0.trailing.equalTo(-16)
                $0.height.equalTo(height)
            }
        }
        lastV = imgV
        return imgV
    }
    
    
    
    private func defaultAttribute()-> [NSAttributedStringKey:Any] {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 6
        return [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),
                NSAttributedStringKey.foregroundColor:
            UIColor.black,
                NSAttributedStringKey.paragraphStyle:
            paragraph,
                NSAttributedStringKey.kern:
            1.5]
    }
    
    private func getTextLayout(text:NSAttributedString)->YYTextLayout{
        
        return YYTextLayout(containerSize: CGSize(width: 343, height: CGFloat(MAXFLOAT)), text: text)!
    }
}
