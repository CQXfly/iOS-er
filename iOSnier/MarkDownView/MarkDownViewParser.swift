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
    case Aside(parser:[MarkDownViewParserType])
    case Blockquote(text:String)
    
    func getText() -> String {
        switch self {
        case  .P(text: let text ):
            return text
            
        case .Img( let src,  _,  _):
            return src
        case .Emoji(let src ):
            return src
        case .Text(let text):
            return text
        case .A(let text,_):
            return text
        case .H1(let text):
            return text
        case .H2(let text):
            return text
        case .Br(let text):
            return text
        case .Li(let text):
            return text
        case .Code(let text):
            return text
        case .Strong(text: let text):
            return  text
        case .Aside(_):
            return "this is aside"
        case .Blockquote(let text):
            return text
        }
    }
    
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
        case .Aside(_):
            return UIFont.systemFont(ofSize: 16)
        case .Blockquote(_):
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
        
        var isAside = false
        
        var asides = [MarkDownViewParserType]()
        
        for dom in doms! {
            
            if(dom.type == .StartTag && dom.data == "aside"){
                isAside = true
            } else if(dom.type == .EndTag && dom.data == "aside"){
                isAside = false
                results.append(.Aside(parser: asides))
                asides.removeAll()
            }
            
            
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
                
                if(src!.hasPrefix("http://") || src!.hasPrefix("https://")){
                    
                } else {
                    src = "http:"+src!
                }
                
                if dom.attributeDic["class"] == "emoji" || (src?.contains("emoji"))!{
                    if(isAside){
                       asides.append(.Emoji(src: src!))
                    } else {
                       results.append(.Emoji(src: src!))
                    }
                    
                }else {
                    if(isAside){
                        asides.append(.Img(src: src!, width: CGFloat(dom.attributeDic["width"] ?? dom.attributeDic["alt width"] ?? "20"), height: CGFloat(dom.attributeDic["height"] ?? dom.attributeDic["alt height"] ?? "20")))
                    } else {
                       results.append(.Img(src: src!, width: CGFloat(dom.attributeDic["width"] ?? dom.attributeDic["alt width"] ?? "20"), height: CGFloat(dom.attributeDic["height"] ?? dom.attributeDic["alt height"] ?? "20")))
                    }
                    
                }
                
                lastDom = dom
                continue
            }
            
            
            if(lastDom.type == .StartTag && dom.type != .StartTag && dom.type != .EndTag){
                if(lastDom.data == "h1"){
                    if(isAside){
                        asides.append(.H1(text: dom.data.htmlencode()))
                    }else {
                        results.append(.H1(text: dom.data.htmlencode()))
                    }
                    
                }
                if(lastDom.data == "h2"){
                    if(isAside){
                        asides.append(.H2(text: dom.data.htmlencode()))
                    }else{
                        results.append(.H2(text: dom.data.htmlencode()))
                    }
                    
                }
                if(lastDom.data == "p"){
                    if(isAside){
                        asides.append(.P(text: dom.data.htmlencode()))
                    }else {
                        results.append(.P(text: dom.data.htmlencode()))
                    }
                    
                }
                
                
                if(lastDom.data == "br"){
                    if isAside {
                        asides.append(.Br(text: dom.data.htmlencode()))
                    } else {
                        results.append(.Br(text: dom.data.htmlencode()))
                    }
                    
                    
                }
                
                if(lastDom.data == "li"){
                    if isAside {
                        asides.append(.Li(text: dom.data.htmlencode()))
                    } else {
                        results.append(.Li(text: dom.data.htmlencode()))
                    }
                    
                    
                }
                
                if(lastDom.data == "code"){
                    if isAside {
                        asides.append(.Code(text: dom.data.htmlencode()))
                    } else {
                        results.append(.Code(text: dom.data.htmlencode()))
                    }
                    
                    
                }
                
                if(lastDom.data == "a"){
//                    results.append(.A(text: dom.data))
                    if(dom.type == .Char){
                        var href = lastDom.attributeDic["href"] ?? ""
                        if(href.hasPrefix("http://") || href.hasPrefix("https://")){
                            
                        } else {
                            href = "http:"+href
                        }
                        
                        
                        if isAside {
                            asides.append(.A(text: dom.data, link: href))
                        } else {
                            results.append(.A(text: dom.data, link: href))
                        }
                       
                    }

                }
                
                if(lastDom.data == "span"){
                    if isAside {
                        asides.append(.Text(text: dom.data.htmlencode()))
                    } else {
                        results.append(.Text(text: dom.data.htmlencode()))
                    }
                    
                    
                }
                
                if(lastDom.data == "text"){
                    if isAside {
                       asides.append(.Text(text: dom.data.htmlencode()))
                    } else {
                       results.append(.Text(text: dom.data.htmlencode()))
                    }
                    
                    
                }
                
                if(lastDom.data == "strong"){
                    if isAside {
                        asides.append(.Strong(text: dom.data.htmlencode()))
                    } else {
                        results.append(.Strong(text: dom.data.htmlencode()))
                    }
                    
                    
                }
                
                if lastDom.data == "blockquote" {
                    if isAside {
                        asides.append(.Blockquote(text: dom.data.htmlencode()))
                    }
                }
                
                if(lastDom.data == "div"){
//                    results.append(.Text(text: dom.data))
                    
                }
                
                if(lastDom.data == "img" && dom.type == .Char) {
                    if isAside {
                        asides.append(.Text(text: dom.data.htmlencode()))
                    } else {
                        results.append(.Text(text: dom.data.htmlencode()))
                    }
                }
                
                lastDom = dom
                continue
            }
            
            if lastDom.type == .EndTag && dom.type == .Char {
                if isAside {
                    asides.append(.Text(text: dom.data.htmlencode()))
                } else {
                    results.append(.Text(text: dom.data.htmlencode()))
                }
            }
            
            
            lastDom = dom
            continue
            
        }
        
        return results
    }
    
}  

extension CGFloat {
    init(_ string:String) {
        if string == "" {
            self.init(Double("20")!)
        } else {
            self.init(Double(string)!)
        }
        
    }
}

extension String {
    func htmlencode()->String{
        var tmp = self
        tmp = tmp.replacingOccurrences(of: "&quot;", with: "\"")
        tmp = tmp.replacingOccurrences(of: "&gt;", with: ">")
        tmp = tmp.replacingOccurrences(of: "&lt;", with: "<")
        tmp = tmp.replacingOccurrences(of: "&apos;", with: "'")
        tmp = tmp.replacingOccurrences(of: "&amp;", with: "&")
        return tmp
    }
    
    
}




