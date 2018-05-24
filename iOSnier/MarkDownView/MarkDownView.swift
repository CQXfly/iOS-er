//
//  MarkDownView.swift
//  iOSnier
//
//  Created by fox on 2018/3/31.
//  Copyright © 2018年 fox. All rights reserved.
//
//<p>找这个功能找了很久，在论坛里看了很多篇帖子，但是自己用都不是很好用，也有很多朋友遇到各种问题，首先是看到了这篇帖子。</p> <aside class="onebox whitelistedgeneric"> <header class="source"> <a href="http://www.iosre.com/t/tweak/1231" rel="nofollow noopener">iosre.com</a> </header> <article class="onebox-body"> <img src="//bbs.iosre.com/uploads/default/603/3bbf17794a09def0.png" width="106" height="106" class="thumbnail"> <h3><a href="http://www.iosre.com/t/tweak/1231" rel="nofollow noopener">使用tweak编写一个插件在运行后截图,为什么这个保存出来是黑屏的图呢</a></h3> <p>//这里因为我需要全屏接图所以直接改了，宏定义iPadWithd为1024，iPadHeight为768， // UIGraphicsBeginImageContextWithOptions(CGSizeMake(640, 960), YES, 0); //设置截屏大小 UIGraphicsBeginImageContextWithOptions(CGSizeMake(iPadWidth, iPadHeight), YES, 0); //设置截屏大小 ...</p> </article> <div class="onebox-metadata"> </div> <div style="clear: both"></div> </aside> <p>然后看到狗神的回复到了这篇帖子</p> <aside class="quote"> <div class="title"> <img alt="" width="20" height="20" src="/letter_avatar_proxy/v2/letter/0/c6cbf5/40.png" class="avatar"> <a href="http://bbs.iosre.com/t/ios/642?source_topic_id=6603">iOS中正确的截屏姿势</a> <a class="badge-wrapper bullet" href="/c/essence-sharing"><span class="badge-category-bg" style="background-color: #3AB54A;"></span><span style="color: #FFFFFF;" class="badge-category clear-badge" title="Supreme contents! For us, by us">Essence Sharing | 干货分享</span></a> </div> <blockquote> 依旧是从博客搬运过来的，<a href="http://blog.0xbbc.com/2014/12/ios%E4%B8%AD%E6%AD%A3%E7%A1%AE%E7%9A%84%E6%88%AA%E5%B1%8F%E5%A7%BF%E5%8A%BF/" rel="nofollow noopener">博客原文</a>。 论坛这边因为没开放HTML标签，所以会失去代码高亮。 如果更习惯看有高亮的代码的话（比如我），也可以直接去看<a href="http://blog.0xbbc.com/2014/12/ios%E4%B8%AD%E6%AD%A3%E7%A1%AE%E7%9A%84%E6%88%AA%E5%B1%8F%E5%A7%BF%E5%8A%BF/" rel="nofollow noopener">博客原文</a>。 如果有其他方法，欢迎补充～ [list] *]第一种 这是iOS 3时代开始就被使用的方法，它被废止于iOS 7。iOS的私有方法，效率很高。#import extern "C" CGImageRef UIGetScreenImage(); UIImage * screenshot(void) NS_DEPRECATED_IOS(3_0,7_0); UIImage * screenshot(){ UIImage *image = [UIImage imageWithCGImage:UIGetScreenImage()]; return image; }[list] *]第二种 [/list]这是在比较常见的截图方法，不过不支持Retina屏幕。UIImage * screenshot(UIView *); UIImage * screenshot(UIView *view){ UIGraphicsBeg… </blockquote> </aside> <p>然后用了第四种方法并把图片存到相册里，然后发现存到相册里面的是全白或者是全黑的。<br>我想着就放弃了，然后就想去砸壳相册做一个监听，砸壳过程中遇到了一些坑，填完一个又来一个就放弃了返回去又去看那个代码。<br>然后就正向开发了一下，使用<br>UIView * view = [UIScreen mainScreen] snapshotViewAfterScreenUpdates:YES];<br>查看了一下这个view是不是有东西，果不其然是有东西的，然后就判断是渲染出了问题，在渲染上下文处view.layer有问题，这是我的推断，后来我就去找绕过这个东西的方法。</p> <p>运气还算好，找到一些原因，发现方法在一些系统上面有bug或者被废弃了，然后误打误撞碰到了<br>[view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];<br>然后就抱着试一试的心态测试了一下，然后居然成功了！！！！</p> <p>然后后面就水到渠成了，将view转成img，然后img转成二进制进行重命名，都迎刃而解了。</p> <p>这个坑从年前卡住了，然后到了近期才有头绪，也算功德圆满！！</p>


import UIKit
import YYKit
import Kingfisher
enum AsideViewType {
    case Github([MarkDownViewParserType])
    case Reply([MarkDownViewParserType])
    case Quote([MarkDownViewParserType])
}

class MarkDownView: UIView {
    
    fileprivate var doms:[MarkDownViewParserType]?
    
    var mdHeight:CGFloat = 0
    var completionRender:((CGFloat)->Void)?
    var linkTapHandler:((String)->Void)?{
        didSet {
            for v in self.subviews {
                if v.isKind(of: MarkDownAsideView.classForCoder()){
                    for vv in v.subviews {
                        if vv.isKind(of: MarkDownView.classForCoder()){
                            let vvv = vv as! MarkDownView
                            vvv.linkTapHandler = linkTapHandler
                        }
                    }
                    
                }
            }
        }
    }
    var url : String? {
        didSet {
            self.doms = MarkDownParser(docs: url!).parser()
            setupUI()
            completionRender?(self.mdHeight)
        }
    }
    
   fileprivate func setupUI(){
        
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
            case .Aside(let parsers):
                createAsideView(parser:parsers,lastV:&lastV)
                continue
                
            case .Blockquote(let text):
                createPLabel(p: text, lastV: &lastV)
                continue
            }
        }
    }
    
    private func createAsideView(parser:[MarkDownViewParserType],lastV:inout UIView) {
        
        
        let markdown : MarkDownAsideView
        
        let filter = parser.filter { (p) -> Bool in
            switch p {
            case .Blockquote(text: _):
                return true
            default:
                return false
            }
        }
        
        if (parser[1].getText() == "GitHub"){
            //那么是github
             markdown = MarkDownAsideView(type:.Github(parser))
        } else if filter.count > 0 {
            markdown = MarkDownAsideView(type:.Reply(parser))
        } else  {
            markdown = MarkDownAsideView(type:.Quote(parser))
        }
        
//        markdown.linkTapHandler = self.linkTapHandler
//        markdown.doms = parser
//        markdown.setupUI()
        addSubview(markdown)
        
        
        
        markdown.tag = lastV.tag + 1
        let height = markdown.mdheight
        if(lastV.tag == 0){
            markdown.snp.makeConstraints{
                $0.top.equalTo(10)
                $0.leading.equalTo(16)
                $0.trailing.equalTo(-16)
                $0.height.equalTo(height)
            }
        } else {
            markdown.snp.makeConstraints{
                $0.top.equalTo(lastV.snp.bottom).offset(10)
                $0.leading.equalTo(16)
                $0.trailing.equalTo(-16)
                $0.height.equalTo(height)
            }
        }
        self.mdHeight += height + 10
        lastV = markdown
        
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
            
          
        } else {
            
            let lastVV = createLabelView(attribute: NSMutableAttributedString(), lastV: &lastV, append: false)
            let attribute = lastVV.attributedText as! NSMutableAttributedString
            lastVV.tag = lastV.tag + 1
            let imgV = UIImageView()
            
            imgV.kf.setImage(with:ImageResource(downloadURL: URL(string: text)!) , placeholder: nil, options: [], progressBlock: nil, completionHandler: { (img, err, cache, url) in
                
                imgV.image = img
                
                let attacnAttr = NSMutableAttributedString.attachmentString(withContent: imgV.image, contentMode:UIViewContentMode.scaleAspectFit, attachmentSize: CGSize(width: 15, height: 15), alignTo: UIFont.systemFont(ofSize: 15), alignment: .center)
                
                attribute.append(attacnAttr)
                
                self.mdHeight -= lastVV.textLayout?.textBoundingSize.height ?? 0
                
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
                print(self.linkTapHandler)
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
                
                print(self.linkTapHandler)
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
                label = createLabelView(attribute: a, lastV: &lastV, append: true,isCode: true)
            } else {
                label = createLabelView(attribute: attr, lastV: &lastV, append: false,isCode: true)
                
                label.textContainerInset = UIEdgeInsetsMake(10, 4, 4, 4)
                
                label.layer.cornerRadius = 6
                label.layer.masksToBounds = true
                label.layer.borderWidth = 1
                label.layer.borderColor = UIColor.purple.cgColor
                 mdHeight += 14
            }
            
        } else {
            label = createLabelView(attribute: attr, lastV: &lastV, append: false,isCode: true)
            
            label.textContainerInset = UIEdgeInsetsMake(10, 4, 4, 4)
            
            label.layer.cornerRadius = 6
            label.layer.masksToBounds = true
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.purple.cgColor
            mdHeight += 14
        }
        
//        label.font = UIFont .systemFont(ofSize: 12);
        if (code.count > 5000) {
            let w = label.textLayout?.textBoundingSize.width
            let h = label.textLayout?.textBoundingSize.height
            let tmpL = UITextView(frame: CGRect(x: 20, y: mdHeight - h! - 14 , width: 343 - 8, height: h!))
            
            tmpL.attributedText = label.attributedText
//            tmpL.numberOfLines = 0
//            tmpL.snp.makeConstraints{
//                $0.left.equalTo(label.snp.left).offset(-4);
//                $0.top.equalTo(label.snp.top).offset(10);
//                $0.bottom.equalTo(label.snp.bottom).offset(4);
//                $0.right.equalTo(label.snp.right).offset(-4);
//            }
            tmpL.textColor = UIColor.red
//            tmpL.backgroundColor = UIColor.red
            self.insertSubview(tmpL, aboveSubview: label)
        }
        
        return label
    }
    
    @discardableResult
    private func createLiLabel(li:String,lastV:inout UIView)->YYLabel{
        
        let tmp = "•  " + li
        let attr = NSMutableAttributedString(string: tmp)
        var at = defaultAttribute()
        at[NSAttributedStringKey.font] =  UIFont.systemFont(ofSize: 16)
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
        at[NSAttributedStringKey.font] = UIFont.boldSystemFont(ofSize: 24)
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
    private func createLabelView(attribute:NSMutableAttributedString,lastV:inout UIView,append:Bool,isCode:Bool = false)->YYLabel {
        
        var label : YYLabel
        
        if append {
            label = lastV as! YYLabel
            label.tag = lastV.tag + 1
            mdHeight -= (label.textLayout?.textBoundingSize.height)!
            
            label.attributedText = attribute
            label.textLayout = getTextLayout(text: attribute,isCode:isCode)
            
            mdHeight += label.textLayout!.textBoundingSize.height
            
            label.snp.updateConstraints{
                $0.height.equalTo(label.textLayout!.textBoundingSize.height)
            }
            
        } else {
            label = YYLabel()
            self.addSubview(label)
            label.tag = lastV.tag + 1
            let textLayout = getTextLayout(text: attribute)
            
            let height = isCode ? textLayout.textBoundingSize.height + 14 :textLayout.textBoundingSize.height
            
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
        
        return [NSAttributedStringKey.font :  UIFont.systemFont(ofSize: 16),
                NSAttributedStringKey.foregroundColor:
            UIColor.black,
                NSAttributedStringKey.paragraphStyle:
            paragraph,
                NSAttributedStringKey.kern:
            1.5]
    }
    
    private func getTextLayout(text:NSAttributedString,isCode:Bool = false)->YYTextLayout{
        
        return YYTextLayout(containerSize: CGSize(width: (isCode ? 335 : 343), height: CGFloat(MAXFLOAT)), text: text)!
    }
    
    
}

class MarkDownAsideView : UIView {
    
    var mdheight : CGFloat = 0
//    private var parsers:[MarkDownViewParserType]!
    
    convenience init(type:AsideViewType){
        self.init()
        self.removeAllSubviews()
        
        switch type {
        case .Github(let parsers):
            setGitUI(parsers)
            break
        case .Reply(let parsers):
            setReplyUI(parsers)
            break
        case .Quote(let parsers):
            setQuoteUI(parsers)
            break
        }
        
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
    }
    
    private func setGitUI(_ parsers:[MarkDownViewParserType]){
        
        //第一第二废弃
        var doms = parsers.dropFirst(2)
        var dom  = doms.first
        
        func isImge(dom:MarkDownViewParserType?)->Bool{
            guard let d = dom else {
                return false
            }
            switch d {
            case .Img(src: _, width: _, height: _):
                return true
            default:
                return false
            }
        }
        
        while !isImge(dom: dom) {
            
            doms = doms.dropFirst()
            dom = doms.first
            
            if dom == nil {
                break
            }

        }
        
        if dom == nil {
            return 
        }
        
        switch dom! {
        case .Img(src: let src , width: _, height: _):
            createImageView(src:src )
        default:
            break
        }
        
        let parser = Array(doms.dropFirst())
        
        let markdown = MarkDownView()
        markdown.doms = parser
        markdown.setupUI()
        addSubview(markdown)
        markdown.snp.makeConstraints{
            $0.left.equalTo(72)
            $0.top.equalTo(-8)
            $0.trailing.equalTo(8)
            $0.height.equalTo(markdown.mdHeight)
        }
        
        self.mdheight = 8 + markdown.mdHeight
        
        
    }
    
    private func setQuoteUI(_ parsers:[MarkDownViewParserType]){
        
        let dom1 = parsers[0]
        var header:UIImageView?
        switch dom1 {
        case .Img(src: let src, width: _, height: _):
            header = createHeadView(src: src)
            break
        default:
            break
        }
        
        var nameLabel:UIView?
        let dom2 = parsers[1]
        switch dom2 {
        case .P(text: let t):
            nameLabel = createLabel(dom: t)
            break
        case .Text(text: let t):
            nameLabel = createLabel(dom: t)
            break
        default:
            break
        }
        
        
        let markdown = MarkDownView()
        markdown.doms = Array(parsers.dropFirst(2))
        markdown.setupUI()
        addSubview(markdown)
        markdown.snp.makeConstraints{
            $0.left.equalTo(8)
            if (header != nil) {
                $0.top.equalTo((header?.snp.bottom)!).offset(8)
            } else {
                $0.top.equalTo(8)
            }
            
            $0.trailing.equalTo(8)
            $0.height.equalTo(markdown.mdHeight)
        }
        
        self.mdheight = 20 + 8 + 8 + markdown.mdHeight
        
    }
    
    private func setReplyUI(_ parsers:[MarkDownViewParserType]){
        setGitUI(parsers)
    }
    
    @discardableResult
    private func createImageView(src:String) -> UIImageView {
        
        let imgV = UIImageView()

        imgV.kf.setImage(with: ImageResource(downloadURL: URL(string: src)!), placeholder: nil, options: [], progressBlock: nil) { (img, err, cache, url) in
            
            imgV.image = img
        }
        addSubview(imgV)
        
        imgV.snp.makeConstraints{
            $0.left.equalTo(8)
            $0.top.equalTo(8)
            $0.width.equalTo(64)
            $0.height.equalTo(64)
        }
        
        return imgV
        
    }
    
    private func createHeadView(src:String) -> UIImageView {
        
        let imgV = UIImageView()
        
        imgV.kf.setImage(with: ImageResource(downloadURL: URL(string: src)!), placeholder: nil, options: [], progressBlock: nil) { (img, err, cache, url) in
            
            imgV.image = img
        }
        addSubview(imgV)
        
        imgV.snp.makeConstraints{
            $0.left.equalTo(8)
            $0.top.equalTo(8)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        
        return imgV
        
    }
    
    @discardableResult
    func createLabel(dom : String) -> UILabel {
        let label = UILabel()
        label.font =  UIFont.systemFont(ofSize: 16)
        label.text = dom
        addSubview(label)
        label.snp.makeConstraints{
            $0.top.equalTo(8)
            $0.leading.equalTo(36)
            $0.trailing.equalToSuperview().offset(-8)
        }
        return label
    }
    
    
}



