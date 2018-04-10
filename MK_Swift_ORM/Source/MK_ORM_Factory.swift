//
//  MK_ORM_Factory.swift
//  MK_Swift_ORM
//
//  Created by MBP on 2018/4/9.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Foundation


public typealias MK_ORM_Protocol = MK_MetaData_Struct_Protocol


public func mk_SetValue(ob:inout MK_ORM_Protocol,value:Any,key:String) {

    let kind = MK_Kind.initWith(type: type(of: ob))

    if kind == .class || kind == .objCClassWrapper{

        MK_MetaData_Class.setValueforKey(ob: ob, key: key, value: value)

    }else if kind == .struct {

        MK_MetaData_Struct.setValueforKey(ob:&ob, key: key, value: value)
    }
}


public func mk_GetValue(ob:inout MK_ORM_Protocol,key:String)->Any{

    let kind = MK_Kind.initWith(type: type(of: ob))
    if kind == .class{

        return MK_MetaData_Class.getValueForKey(ob: ob, key: key)

    }else if kind == .struct {

        return MK_MetaData_Struct.getValueForKey(ob: &ob, key: key)
    }
    return NSNull()
}



