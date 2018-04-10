//
//  MK_MetaData_Struct.swift
//  MK_Swift_ORM
//
//  Created by MBP on 2018/4/10.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Foundation


public protocol MK_MetaData_Struct_Protocol{

    mutating func getStructPointHead() -> UnsafeMutablePointer<Int8>

}

public extension MK_MetaData_Struct_Protocol {

    mutating func getStructPointHead() -> UnsafeMutablePointer<Int8> {

        let stride = typeTransition(type(of: self)).stride
        return withUnsafeMutablePointer(to: &self) {
            return UnsafeMutableRawPointer($0).bindMemory(to: Int8.self, capacity: stride)
        }
    }
}


class MK_MetaData_Struct {


    static func setValueforKey(ob: inout MK_MetaData_Struct_Protocol,key:String,value:Any){

        let ppDic = getStruct_PropertyDic(ob: ob)
        let headP = ob.getStructPointHead()

        guard let pp = ppDic[key] else {return}
        
        guard pp.type == type(of: value) else { return }

        try? typeTransition(pp.type).write(value, to: UnsafeMutableRawPointer(headP.advanced(by: pp.off)))
    }

    static func getValueForKey(ob:inout MK_MetaData_Struct_Protocol,key:String)->Any {

        let ppDic = getStruct_PropertyDic(ob: ob)
        let headP = ob.getStructPointHead()

        guard let pp = ppDic[key] else {
            return NSNull()
        }
        return typeTransition(pp.type).get(from: UnsafeMutableRawPointer(headP.advanced(by: pp.off)))
    }

    static func getStruct_PropertyDic(ob:Any) -> [String:MK_Property]{

        let mi = Mirror.init(reflecting: ob)

        var offSet:Int = 0
        var dic : [String:MK_Property] = [:]

        for item in mi.children {

            if item.label == nil {break}
            let name = item.label!
            let tp = type(of: item.value)
            let res = MK_Property.init(name: name, off: offSet, type:tp)
            let stride = typeTransition(tp).stride
            let fillSize = stride%8
            let needSize = fillSize == 0 ? stride : (8 - stride%8) + stride
            offSet = offSet + needSize
            dic[name] = res
        }
        return dic
    }


}
