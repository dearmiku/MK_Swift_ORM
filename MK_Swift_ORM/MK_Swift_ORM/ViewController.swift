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

}



class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        

        let ob = TT()

        let va = MK_MetaData_Class.getValueForKey(ob: ob, key: "num")



        
    }

}

