//
//  MarkDownViewParser.swift
//  iOSnier
//
//  Created by fox on 2018/3/31.
//  Copyright © 2018年 fox. All rights reserved.
//

import UIKit

enum MarkDownViewParserType {
    case H1(text:String)
    case H2(text:String)
    case P(text:String)
    case Img(src:String,width:CGFloat,height:CGFloat)
    case Emoji(src:String)
    case Text(text:String)
    case A(text:String,link:String)
    case Br(text:String)
    case Li(text:String)
    case Code(text:String)
    case Strong(text:String)
    
    func getFont(type:MarkDownViewParserType) -> UIFont {
        switch type {
        case  .P(text: _):
            return UIFont.systemFont(ofSize: 16)

        case .Img( _,  _,  _):
            return UIFont.systemFont(ofSize: 16)
        case .Emoji(_):
            return UIFont.systemFont(ofSize: 16)
        case .Text(_):
            return UIFont.systemFont(ofSize: 16)
        case .A(_,_):
            return UIFont.systemFont(ofSize: 16)
        case .H1(_):
            return UIFont.systemFont(ofSize: 16)
        case .H2(_):
            return UIFont.systemFont(ofSize: 16)
        case .Br(_):
            return UIFont.systemFont(ofSize: 16)
        case .Li(_):
            return UIFont.systemFont(ofSize: 16)
        case .Code(_):
            return UIFont.systemFont(ofSize: 16)
        case .Strong(text: _):
            return UIFont.systemFont(ofSize: 16)
        }
    }
}

struct MarkDownParser {
    private var doms:[HTMLToken]?
    init(docs:String) {
        doms = HTMLTreeBuilder(docs).parse()
    }
    
    func parser()->[MarkDownViewParserType]{
        var results = [MarkDownViewParserType]()
        
        var lastDom = HTMLToken()
        
        for dom in doms! {
            if(dom.type == .EndTag){
                lastDom = dom
                continue
            }
            
            if(dom.data == "img" && dom.type == .StartTag){
                var src = dom.attributeDic["src"]
                guard (src != nil) else {
                    lastDom = dom
                    continue
                }
                
                if(src!.hasPrefix("http://") || src!.hasPrefix("http://")){
                    
                } else {
                    src = "http:"+src!
                }
                
                if dom.attributeDic["class"] == "emoji" || (src?.contains("emoji"))!{
                    results.append(.Emoji(src: src!))
                }else {
                    results.append(.Img(src: src!, width: CGFloat(dom.attributeDic["width"]!), height: CGFloat(dom.attributeDic["height"]!)))
                }
                
                lastDom = dom
                continue
            }
            
            
            if(lastDom.type == .StartTag && dom.type != .StartTag && dom.type != .EndTag){
                if(lastDom.data == "h1"){
                    results.append(.H1(text: dom.data))
                }
                if(lastDom.data == "h2"){
                    results.append(.H2(text: dom.data))
                }
                if(lastDom.data == "p"){
                    results.append(.P(text: dom.data))
                }
                
                
                if(lastDom.data == "br"){
                    results.append(.Br(text: dom.data))
                    
                }
                
                if(lastDom.data == "li"){
                    results.append(.Li(text: dom.data))
                    
                }
                
                if(lastDom.data == "code"){
                    results.append(.Code(text: dom.data))
                    
                }
                
                if(lastDom.data == "a"){
//                    results.append(.A(text: dom.data))
                    if(dom.type == .Char){
                       results.append(.A(text: dom.data, link: lastDom.attributeDic["href"]!))
                    }

                }
                
                if(lastDom.data == "span"){
                    results.append(.Text(text: dom.data))
                    
                }
                
                if(lastDom.data == "text"){
                    results.append(.Text(text: dom.data))
                    
                }
                
                if(lastDom.data == "strong"){
                    results.append(.Strong(text: dom.data))
                    
                }
                
                if(lastDom.data == "div"){
//                    results.append(.Text(text: dom.data))
                    
                }
                
                lastDom = dom
                continue
            }
            
            if lastDom.type == .EndTag && dom.type == .Char {
                results.append(.Text(text: dom.data))
            }
            
            
            lastDom = dom
            continue
            
        }
        
        return results
    }
}  

extension CGFloat {
    init(_ string:String) {
        self.init(Double(string)!)
    }
}
