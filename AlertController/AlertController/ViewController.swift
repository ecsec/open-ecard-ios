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

    @IBOutlet weak var tf2: UITextView!
    
    
    @IBAction func defaultHandler(_ sender: UIButton) {
        doThingsWithFramework()
        
    }

var session: NFCTagReaderSession?
func doThingsWithFramework() {
        let framework = NFCTestFrameworkInstance()
    
    class CallableThingyImp :NSObject,CallableThingy{
        
        let tfref:UITextView
        init(tf:UITextView){
            tfref = tf
        }
        
        func call(_ s: String){
            tfref.text=s
        }
    }
    let cti = CallableThingyImp(tf:tf2)
        let caller = framework?.getThingyCaller()
    caller?.call(cti)
    }
   
    

}
