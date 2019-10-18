//
//  ViewController.swift
//  AlertController
//
//  Created by MIHIR PIPERMITWALA on 18/06/18.
//  Copyright © 2018 Mihir Pipermitwala. All rights reserved.
//

import UIKit
import CoreNFC
import OpenEcard

class ViewController: UIViewController {

    class ContextCompletion: NSObject, OpeneCardServiceHandlerProtocol{
        var frm : OpenEcardProtocol? = nil;
       
        override init(){
        }
        
      
        func setFrm(frm : OpenEcardProtocol){
            self.frm = frm;
        }
        
        func onSuccess() {
            print("Context process completed successfully.")
            frm!.triggerNFC()
            
        }
        
        func onFailure(_ response: (NSObjectProtocol & ServiceErrorResponseProtocol)!) {
            print("Context process completed successfully.")
        }
    }
    
    lazy var frm = createOpenEcard()
    var helper = ContextCompletion()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
     //  doSomethingWithOpeneCard()
        //  doThingsWithProcessorFramework()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var tf2: UITextView!
    
    @IBAction func defaultHandler(_ sender: UIButton) {
        
        doSomethingWithOpeneCard()
        // doThingsWithProcessorFramework()
        
    }

    func doSomethingWithOpeneCard() {
        self.frm = createOpenEcard()
        
        print(frm)
        
        let context = frm?.context()
        print(context)
        

        helper.setFrm(frm: frm!)
        context?.start(helper)


    }
    
    func doThingsWithProcessorFramework(){
//        let frm = getFrameworkInstance()
//        frm?.fun()
//        frm?.fun("a string")
//        frm?.otherfun(42)
//        
//        let imp = frm?.getSomeImp()
//        imp?.someFun()
//        
//        let innerimp = frm?.getSomeInnerImp()
//        innerimp?.someInnerFun()
//        innerimp?.someFun()
     //  let frm2 = createSomeInnerObject()
     //   frm2?.innerFun()
    }

    

}
