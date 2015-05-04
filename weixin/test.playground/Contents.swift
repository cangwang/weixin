//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var locList = ["上海","东京","大连","上海","北京","上海"]



//获取正确的删除索引
func getRevmoveIndex<T:Equatable>(value:T,aArray:[T]) ->[Int] {
    var indexArray = [Int]()
    var correctArray = [Int]()
    
    //获取指定值在数组中的索引并保存
    for (index,_) in enumerate(aArray) {
        if value == aArray[index] {
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
func removeValuefromArray<T:Equatable>(value:T,inout aArray:[T]) {
    var correctArray = [Int]()
    
    correctArray = getRevmoveIndex(value, aArray)
    
    for index in correctArray {
        aArray.removeAtIndex(index)
    }
}

removeValuefromArray("上海",&locList)
