//
//  ReplyCellViewModel.swift
//  iOSnier
//
//  Created by fox on 2018/4/4.
//  Copyright © 2018年 fox. All rights reserved.
//

import UIKit
class ReplyCellViewModel {
    let markDownV:MarkDownView
    let height:CGFloat
    init(model:Post) {
        self.markDownV = MarkDownView()
        self.markDownV.url = model.cooked
        self.height = self.markDownV.mdHeight
    }
}
