//
//  WXMessage.swift
//  weixin
//
//  Created by air on 15/4/18.
//  Copyright (c) 2015年 air. All rights reserved.
//

import Foundation

//好友消息结构
struct WXMessage {
    var body = ""
    var from = ""
    var isComposing = false
    var isDelay = false
    var isMe = false
}
//状态结构
struct Zhuangtai {
    var name = ""
    var isOnline = false
}

//获取正确的删除索引
func getRevmoveIndex(value:String,aArray:[WXMessage]) ->[Int] {
    var indexArray = [Int]()
    var correctArray = [Int]()
    
    //获取指定值在数组中的索引并保存
    for (index,_) in enumerate(aArray) {
        if value == aArray[index].from {
            indexArray.append(index)
        }
    }
    
    //计算正确的删除索引
    for(index,orginIndex) in enumerate(indexArray){
        //用指定值原数组中得索引，减去数组中的索引
        var y = 0
        y = orginIndex - index
        
        //添加到正确索引
        correctArray.append(y)
    }
    
    //返回正确的删除索引
    return correctArray
    
}

//从数组中删除指定的元素
func removeValuefromArray(value:String,inout aArray:[WXMessage]) {
    var correctArray = [Int]()
    
    correctArray = getRevmoveIndex(value, aArray)
    
    for index in correctArray {
        aArray.removeAtIndex(index)
    }
}
