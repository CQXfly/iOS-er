//
//  DateFile.swift
//  iOSnier
//
//  Created by fox on 2018/3/23.
//  Copyright © 2018年 fox. All rights reserved.
//

import Foundation
import QXKit

extension String {
    //MARK: 2018-03-19T09:15:31.363Z 这种格式转时间戳 这种时间转出来有问题 少8个小时
    public func transformBTDateString()->String {
        let s = String(self.dropLast(5))
        let s2 = s.replacingOccurrences(of: "T", with: " ")
        let formatter = Date.formatter1
        formatter.timeZone = TimeZone(abbreviation: "GMT+0800")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: String(s2))
        return "\(date!.timeIntervalSince1970 + 60*60*8)"
    }
}
