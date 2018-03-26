//
//  NetCoreKit.swift
//  NetCore
//
//  Created by fox on 2018/3/2.
//  Copyright © 2018年 Eric. All rights reserved.
//

import Foundation
import Alamofire



public class HTTPNetCoreKit {
    
    private var headers:[String:String]
    
    public static let sharedInstance = HTTPNetCoreKit()
    
    init() {
        headers = [:]
    }
    
    /// `T`为 继承codable协议的对象 方法解析成功会返回[T]
    /// - parameters:
    ///   - url:合法url
    ///   - success:成功的回调
    ///   - error:出错的回调
    public func get<T>(url:String,success:@escaping (T)->Void,error:@escaping(_ err:Error)->Void) where T:Decodable{
        get(url: url, nil, success: success, error: error)
    }
    
    /// `T`为 继承codable协议的对象 方法解析成功会返回[T]
    /// - parameters:
    ///   - url:合法url
    ///   - parameters: 参数
    ///   - success:成功的回调
    ///   - error:出错的回调
    public func get<T>(url:String,_ parameters:[String:Any]?,success: @escaping (T)->Void,error:@escaping(_ err:Error)->Void) where T:Decodable {
        
        request(url: url, parameters, method: .get, success: success, error: error)
        
    }
    
    public func post<T>(url:String,success:@escaping (T)->Void,error:@escaping(_ err:Error)->Void) where T:Decodable{
        post(url: url, success: success, error: error)
    }
    
    public func post<T>(url:String,_ parameters:[String:Any]?,success: @escaping (T)->Void,error:@escaping(_ err:Error)->Void) where T:Decodable {
        
        request(url: url, parameters, method: .post, success: success, error: error)
        
    }
    
    private func request<T>(url:String,_ parameters:[String:Any]?,method:HTTPMethod,success: @escaping (T)->Void,error:@escaping(_ err:Error)->Void) where T:Decodable{
        Alamofire.request(url, method:method, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success:
                guard let data = response.data else {
                    error("no data" as! Error)
                    return
                }
                
//                print(try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)))
                let decoder = JSONDecoder()
                let model = try! decoder.decode(T.self, from: data)
                success(model)
                
            case .failure(let err):
                error(err)
            }
        }
    }
    
    public func addHeader(key:String,value:String){
        headers[key] = value
    }
}
