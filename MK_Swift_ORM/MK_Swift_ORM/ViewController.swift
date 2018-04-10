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

    var num:Int? = 1

    var str:NSString = "12345" as NSString

}

struct SS : MK_MetaData_Struct_Protocol{


    var age:Int = 16

    var yy:Int8 = 10

    var name:String = "11111111"


}

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var ob = SS()

        let p = ob.getStructPointHead()
        let pp = MK_MetaData_Struct.getStruct_PropertyDic(ob: ob)["name"]!


        try? typeTransition(pp.type).write("2222", to: UnsafeMutableRawPointer(p.advanced(by: pp.off)))


        print(ob)

    }

}

