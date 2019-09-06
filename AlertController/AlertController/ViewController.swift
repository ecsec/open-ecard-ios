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
        beginScanning()
    }
    
    
    @IBAction func defaultAlertWithFormActionHandler(_ sender: UIButton) {
        beginScanning()
        
    }

var session: NFCTagReaderSession?
func beginScanning() {
		let sdk = NFCTestFrameworkInstance()
		let nfc = sdk?.getNFCStarter()

        let start = DispatchTime.now()
		nfc?.startSession()
        
        
        while(nfc?.isAllReady() ?? true == false){
            sleep(1)
        }
        
        let afterSess = DispatchTime.now()

        
        var count = 0
           
        while(nfc?.readSuccessfully() ?? true == true){
            
            count+=3
            sendAPDUsAndWait(nfc:nfc)
            mysleep(secs:0)

            var msg: String = "apdus: "
            msg.append(String(count))
            nfc?.setAlertMessage(msg)
            
        }
     
        print("Read \(count) apdus")
     
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let interval = Double(nanoTime) / 1000_000_000
        let setSessTime = Double(afterSess.uptimeNanoseconds - start.uptimeNanoseconds) / 1000_000_000
        let time4Reading = Double(end.uptimeNanoseconds - afterSess.uptimeNanoseconds) / 1000_000_000
        
        print("time for session \(setSessTime)")
        print("time for reading \(time4Reading)")
        
        print("time for all: \(interval)")
        
        
        nfc?.invalidateSession()
    }
    func mysleep(secs: integer_t){
        
               for var i in (0..<secs){
                   sleep(1)
                   print("sleepin for a " , secs , " secs before invalidating the session", secs-i)
               }
    }
    func sendAPDUsAndWait(nfc: NFCStarter?){
        nfc?.sendTestAPDU_selectMF()
        while(nfc?.isAllReady() ?? true == false){}
        
        nfc?.sendTestAPDU_selectEFDIR()
        while(nfc?.isAllReady() ?? true == false){}
        
        nfc?.sendTestAPDU_getREAD_EFDIR()
        while(nfc?.isAllReady() ?? true == false){}
        
        }

}
