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

    @IBAction func defaultAlertActionHandler(_ sender: UIButton) {
        //Init AlertController
        let alertController = UIAlertController.init(title: "Alert Title", message: "This is Alert Message", preferredStyle: .alert)
        //Add action in AlertController
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            print("Ok Button Pressed")
        }))
        //Second way of Add Action in AlertController
        //Init Alert Action
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("Cancel Button Pressed")
        })
        //This for add Alert Action into alertController
        alertController.addAction(cancelButton)
        
        
        //Show AlertController Via PresentViewController
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func defaultActionsheetActionHandler(_ sender: UIButton) {
        //Init AlertController
        let alertController = UIAlertController.init(title: "Actionsheet", message: "This is Action Message", preferredStyle: .actionSheet)
        //Add action in AlertController
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            print("Ok Button Pressed")
        }))
        //Second way of Add Action in AlertController
        //Init Alert Action
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("Cancel Button Pressed")
        })
        //This for add Alert Action into alertController
        alertController.addAction(cancelButton)
        
        //Show AlertController Via PresentViewController
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func defaultAlertWithFormActionHandler(_ sender: UIButton) {
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
