//
//  RJAsyncClosureCaller.swift
//  iOSnier
//
//  Created by fox on 2018/5/7.
//  Copyright © 2018年 fox. All rights reserved.
//
import Foundation
//
public class RJAsyncClosureCaller: NSObject {
    @objc public static func call(closure: Any, finish: @escaping RJAsyncCallback) -> Void {
        (closure as? RJAsyncClosure)?(finish)
    }
}
