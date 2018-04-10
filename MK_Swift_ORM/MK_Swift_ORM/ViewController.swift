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


class TT:SupClass,MK_ORM_Protocol{

    var num:Int = 1

    var str:NSString = "12345" as NSString

}


struct SS:MK_ORM_Protocol{


    var age:Int = 16

    var yy:Int8 = 10

    var name:String = "11111111"


}

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var ob = (SS() as MK_ORM_Protocol)
        var ob1 = (TT()as MK_ORM_Protocol)

        print(ob)
        print((ob1 as! TT).num)

        mk_SetValue(ob: &ob, value: "2222", key: "name")
        mk_SetValue(ob: &(ob1), value:Int(2), key: "num")

        print(ob)
        print((ob1 as! TT).num)

    }

}

