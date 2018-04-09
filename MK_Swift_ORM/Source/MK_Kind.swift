//
//  Kind.swift
//  MK_Swift_ORM
//
//  Created by MBP on 2018/4/9.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Foundation

enum MK_Kind {

    case `struct`
    case `enum`
    case optional
    case opaque
    case tuple
    case function
    case existential
    case metatype
    case objCClassWrapper
    case existentialMetatype
    case foreignClass
    case heapLocalVariable
    case heapGenericLocalVariable
    case errorObject
    case `class`


    init(flag: Int) {
        switch flag {
        case 1: self = .struct
        case 2: self = .enum
        case 3: self = .optional
        case 8: self = .opaque
        case 9: self = .tuple
        case 10: self = .function
        case 12: self = .existential
        case 13: self = .metatype
        case 14: self = .objCClassWrapper
        case 15: self = .existentialMetatype
        case 16: self = .foreignClass
        case 64: self = .heapLocalVariable
        case 65: self = .heapGenericLocalVariable
        case 128: self = .errorObject
        default: self = .class
        }
    }


    static func initWith(type:Any.Type)->MK_Kind{

        let kind = unsafeBitCast(type, to: UnsafePointer<Int>.self)
        return MK_Kind.init(flag: kind.pointee)
    }

}
