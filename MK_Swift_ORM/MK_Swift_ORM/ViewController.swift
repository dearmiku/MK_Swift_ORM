//
//  ViewController.swift
//  MK_Swift_ORM
//
//  Created by MBP on 2018/4/9.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Cocoa

class grandClass:NSObject{
    //var ok:String = ""
}

class SupClass:grandClass{

    //var age:Int = 10

}


class TT:SupClass{

    var num:Int = 0

}



class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let ob = TT()

        let value = MK_MetaData_Class.getClass_PropertyArr(ob: ob)
        let ob_t = MK_MetaData_Class.headPointerOfClass(ob: ob)

        let pp = value.first!

        UnsafeMutableRawPointer(ob_t.advanced(by: pp.off)).assumingMemoryBound(to: Int.self).pointee = 10
        

        
    }

}

