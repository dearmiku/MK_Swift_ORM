//
//  MK_AnyExtension.swift
//  MK_Swift_ORM
//
//  Created by MBP on 2018/4/10.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Foundation

protocol MK_AnyExtension {}

extension MK_AnyExtension {

    static func get(from p:UnsafeMutableRawPointer)->Any{
        return p.assumingMemoryBound(to: self).pointee
    }

    static func write(_ value: Any, to p: UnsafeMutableRawPointer) throws {
        guard let this = value as? Self else {
            fatalError("Type mismatch")
        }
        p.assumingMemoryBound(to: self).initialize(to: this)
    }
}


func typeTransition(_ type:Any.Type)->MK_AnyExtension.Type{

    struct Extensions : MK_AnyExtension {}
    var extensions: MK_AnyExtension.Type = Extensions.self
    withUnsafePointer(to: &extensions) { pointer in
        UnsafeMutableRawPointer(mutating: pointer).assumingMemoryBound(to: Any.Type.self).pointee = type
    }
    return extensions
}
