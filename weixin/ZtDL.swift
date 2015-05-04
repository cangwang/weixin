//
//  ZtDL.swift
//  weixin
//
//  Created by air on 15/4/19.
//  Copyright (c) 2015年 air. All rights reserved.
//

import Foundation
//状态协议
protocol ZtDL {
    func isOn(zt:Zhuangtai)
    func isOff(zt:Zhuangtai)
    func meOff()
}