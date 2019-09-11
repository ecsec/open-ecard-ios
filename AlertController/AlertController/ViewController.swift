//
//  ViewController.swift
//  AlertController
//
//  Created by MIHIR PIPERMITWALA on 18/06/18.
//  Copyright © 2018 Mihir Pipermitwala. All rights reserved.
//

import UIKit
import CoreNFC
import NFCTestFramework

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    @IBAction func defaultHandler(_ sender: UIButton) {
        doThingsWithFramework()
        
    }

var session: NFCTagReaderSession?
func doThingsWithFramework() {
        let framework = NFCTestFrameworkInstance()
    
    class CallableThingyImp :NSObject,CallableThingy{
        func call(_ s: String){
            print(s)
        }
    }
    let cti = CallableThingyImp()
        let caller = framework?.getThingyCaller()
    caller?.call(cti)
    }
   
    

}
