//
//  MK_MetaData.swift
//  MK_Swift_ORM
//
//  Created by MBP on 2018/4/9.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Foundation


struct MK_MetaData_Class {

    fileprivate static var typePropertyCacheDic:[String:[String:MK_Property]] = [:]


    static func setValueforKey(ob:Any,key:String,value:Any){

        let ppDic = getClass_PropertyDic(ob: ob)
        let headP = getOBPointHead(ob: ob as AnyObject)

        guard let pp = ppDic[key] else {return}
        guard pp.type == type(of: value) else { return }

        try? typeTransition(pp.type).write(value, to: UnsafeMutableRawPointer(headP.advanced(by: pp.off)))
    }

    static func getValueForKey(ob:Any,key:String)->Any {

        let ppDic = getClass_PropertyDic(ob: ob)
        let headP = getOBPointHead(ob: ob as AnyObject)

        guard let pp = ppDic[key] else {
            return NSNull()
        }
        return typeTransition(pp.type).get(from: UnsafeMutableRawPointer(headP.advanced(by: pp.off)))
    }

    
    static func getOBPointHead(ob:AnyObject) -> UnsafeMutablePointer<Int8> {
        
        let stride = MemoryLayout.stride(ofValue: type(of: ob))
        let opaqueP = Unmanaged.passUnretained(ob).toOpaque()
        let mutableTypedP = opaqueP.bindMemory(to: Int8.self, capacity: stride)
        return UnsafeMutablePointer<Int8>(mutableTypedP)
    }



    static func getClass_PropertyDic(ob:Any) -> [String:MK_Property]{
        
        let tt = type(of: ob)

        let typeInfo_t = unsafeBitCast(tt.self, to: UnsafePointer<Int>.self)
        let metaData = UnsafeRawPointer(typeInfo_t).assumingMemoryBound(to: MK_Class.self).pointee
        
        guard let ro = metaData.class_rw_t()?.pointee.class_ro_t()?.pointee else {
            return [:]
        }

        ///Check the cache
        if let cachArr = MK_MetaData_Class.typePropertyCacheDic[String.init(cString: ro.name)] {
            return cachArr
        }


        let mi = Mirror.init(reflecting: ob)
        let count = mi.children.count
        var ivarArr = Array(UnsafeBufferPointer.init(start: ro.ivars, count: Int(count)))
        
        var ivarDic:[String:MK_ivar] = ivarArr.reduce(into: Dictionary<String,MK_ivar>.init()) { (res, inport) in
            res[String.init(cString: inport.name)] = inport
        }
        var res = mi.children.reduce(into: Array<MK_Property>.init()) { (res, item) in
            guard let name = item.label,let ivar = ivarDic[name] else {return}
            let pp = MK_Property.init(name: name, off: Int(ivar.off.pointee), type: type(of: item.value))
            res.append(pp)
        }

        var superMi = mi.superclassMirror
        
        func getSuperIvarArr(){
            
            guard let Mi = superMi else {
                return
            }
            let arr = getClass_PropertyArr(type: Mi.subjectType, num: Int(Mi.children.count))
            var dic:[String:MK_ivar] = arr.reduce(into: Dictionary<String,MK_ivar>.init()) { (res, inport) in
                res[String.init(cString: inport.name)] = inport
            }
            let supRes = Mi.children.reduce(into: Array<MK_Property>.init()) { (res, item) in
                guard let name = item.label,let ivar = dic[name] else {return}
                let tt = type(of: item.value)
                let pp = MK_Property.init(name: name, off: Int(ivar.off.pointee), type: type(of: item.value))
                res.append(pp)
            }
            res.append(contentsOf: supRes)
            
            superMi = Mi.superclassMirror
            getSuperIvarArr()
        }
        getSuperIvarArr()

        var dic:[String:MK_Property] = [:]
        res.forEach { (item) in
            dic[item.name] = item
        }
        MK_MetaData_Class.typePropertyCacheDic[String.init(cString: ro.name)] = dic
        return dic
    }
    
    
    fileprivate static func getClass_PropertyArr(type:Any.Type,num:Int)->[MK_ivar]{
        
        let typeInfo_t = unsafeBitCast(type.self, to: UnsafePointer<Int>.self)
        let metaData = UnsafeRawPointer(typeInfo_t).assumingMemoryBound(to: MK_Class.self).pointee
        
        guard let ro = metaData.class_rw_t()?.pointee.class_ro_t()?.pointee else {
            return []
        }
        let ivarArr = Array(UnsafeBufferPointer.init(start: ro.ivars, count: num))
        
        return ivarArr
    }
    
    
}




extension MK_MetaData_Class {
    
    struct MK_ivar {
        
        var mask1:Int32
        
        var off:UnsafePointer<CChar>
        
        var name:UnsafePointer<CChar>
        
        var mask2:UInt32
        var mask3:UInt32
        
    }
    
    struct MK_class_ro_t {
        
        var flags: Int32
        var instanceStart: Int32
        var instanceSize: Int32
        
        ///Only supports 64-bit
        var reserved:UInt32
        
        var mask1:Int
        
        var name:UnsafePointer<CChar>
        
        var mask2:Int
        var mask3:Int
        
        var ivars:UnsafePointer<MK_ivar>
        
    }
    
    
    struct MK_class_rw_t {
        
        var flags: Int32
        var version: Int32
        var ro: UInt
        
        func class_ro_t() -> UnsafePointer<MK_class_ro_t>? {
            return UnsafePointer<MK_class_ro_t>(bitPattern: self.ro)
        }
    }
    
    
    struct MK_Class {
        
        var kind: Int
        
        var superclass: Any.Type?
        var mask1: Int
        var mask2: Int
        var databits: UInt
        
        
        func class_rw_t() -> UnsafePointer<MK_class_rw_t>? {
            
            /// Only supports 64-bit
            let fast_data_mask: UInt64 = 0x00007ffffffffff8
            let databits_t: UInt64 = UInt64(self.databits)
            return UnsafePointer<MK_class_rw_t>(bitPattern: UInt(databits_t & fast_data_mask))
            
        }
    }
}
