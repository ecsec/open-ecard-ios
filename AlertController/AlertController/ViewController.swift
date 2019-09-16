//
//  ViewController.swift
//  AlertController
//
//  Created by MIHIR PIPERMITWALA on 18/06/18.
//  Copyright © 2018 Mihir Pipermitwala. All rights reserved.
//

import UIKit
import CoreNFC
import MyFrameworkProtocol

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
   //       doThingsWithProcessorFramework()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var tf2: UITextView!
    
    var i:Int32=0
    
    @IBAction func defaultHandler(_ sender: UIButton) {
        doThingsWithProcessorFramework()
        
    }

    func doThingsWithProcessorFramework(){
        let frm = createSomeObject()
  
        i += 1
    }

    

}
