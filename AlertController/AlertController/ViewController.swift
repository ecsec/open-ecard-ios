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
import OpenEcard.open_ecard_mobile_lib

class ViewController: UIViewController {
    
    class EacControllerStart: NSObject, ControllerCallbackProtocol, EacInteractionProtocol {
        let frm : OpenEcardProtocol;
        var msgHandler : NFCOverlayMessageHandlerProtocol?;
        var v :ViewController
        
        init(frm : OpenEcardProtocol, v:ViewController) {
            self.v = v
            self.frm = frm
            self.msgHandler = nil
            super.init()
        }
        
        
        func requestCardInsertion() {
            //not used
        }
        func requestCardInsertion(_ msgHandler: (NSObjectProtocol & NFCOverlayMessageHandlerProtocol)!) {
            print("requestCardInsertion b ")
//            msgHandler.setText("Du die Kadde her!")
            
            DispatchQueue.global().async {
                self.frm.triggerNFC()
            }
        }
        
        func onPinRequest(_ attempt: Int32, withEnterPin enterPin: (NSObjectProtocol & ConfirmPasswordOperationProtocol)!) {
            print("onPinRequest")

            DispatchQueue.main.async{

                let alert = UIAlertController(title: "Enter pin", message: "", preferredStyle: .alert)
                           //Add the text field. You can configure it however you need.
                alert.addTextField { (pin) in
                    pin.placeholder = "pin/can"
                    pin.isSecureTextEntry = true
                }

                //the cancel action doing nothing
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

                //the confirm action taking the inputs
                let acceptAction = UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
                    guard let pin = alert?.textFields?[0] else {
                        print("Issue with Alert TextFields")
                        return
                    }

                    DispatchQueue.global(qos: .background).async{
                        enterPin.enter(pin.text)
                    }

                })

                //adding the actions to alertController
                alert.addAction(acceptAction)
                alert.addAction(cancelAction)

                // Presenting the alert
                self.v.present(alert, animated: true, completion: nil)
            }

        }
        

        func onPinCanRequest(_ enterPinCan: (NSObjectProtocol & ConfirmTwoPasswordsOperationProtocol)!) {
            print("onPinCanRequest")
            DispatchQueue.main.async{

                let alert = UIAlertController(title: "Enter pin/can", message: "", preferredStyle: .alert)
                           //Add the text field. You can configure it however you need.
                alert.addTextField { (pin) in
                    pin.placeholder = "pin"
                    pin.isSecureTextEntry = true
                }
                alert.addTextField { (can) in
                    can.placeholder = "can"
                    can.isSecureTextEntry = true
                }

                //the cancel action doing nothing
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

                //the confirm action taking the inputs
                let acceptAction = UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
                    guard let pin = alert?.textFields?[0], let can = alert?.textFields?[1] else {
                        print("Issue with Alert TextFields")
                        return
                    }

                    DispatchQueue.global(qos: .background).async{
                        enterPinCan.enter(pin.text, withSecondPassword: can.text)
                    }

                })

                //adding the actions to alertController
                alert.addAction(acceptAction)
                alert.addAction(cancelAction)

                // Presenting the alert
                self.v.present(alert, animated: true, completion: nil)
            }

        }

        func onCanRequest(_ enterCan: (NSObjectProtocol & ConfirmPasswordOperationProtocol)!) {
            print("onCanRequest")
            DispatchQueue.main.async{

                let alert = UIAlertController(title: "Enter can", message: "", preferredStyle: .alert)
                           //Add the text field. You can configure it however you need.
                alert.addTextField { (can) in
                    can.placeholder = "can"
                    can.isSecureTextEntry = true
                }

                //the cancel action doing nothing
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

                //the confirm action taking the inputs
                let acceptAction = UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
                    guard let can = alert?.textFields?[0] else {
                        print("Issue with Alert TextFields")
                        return
                    }

                    DispatchQueue.global(qos: .background).async{
                        enterCan.enter(can.text)
                    }

                })

                //adding the actions to alertController
                alert.addAction(acceptAction)
                alert.addAction(cancelAction)

                // Presenting the alert
                self.v.present(alert, animated: true, completion: nil)
            }
        }
        
        func onServerData(_ data: (NSObjectProtocol & ServerDataProtocol)!, withTransactionData transactionData: String!, withSelectReadWrite selectReadWrite: (NSObjectProtocol & ConfirmAttributeSelectionOperationProtocol)!) {
    ///        msgHandler?.setText("Allowing attributes automatically")
            selectReadWrite.enter(data as? [NSObjectProtocol & SelectableItemProtocol], withWrite: nil)
        }
        
        func onCardAuthenticationSuccessful() {
            print("onCardAuthenticationSuccessful")
        }
        
        func onCardRecognized() {
            print("on card recognized the wrong one")
        }
      
        func onCardBlocked() {
            print("onCardBlocked")
        }
        
        func onCardDeactivated() {
            print("onCardDeactivated")
        }
        
        func onCardInteractionComplete() {
            print("onCardInteractionComplete")
        }
        func onTransactionInfo(_ data: String!) {
            print("onTransactionInfo");
        }
        
        func onCardRemoved() {
            print("onCardRemoved");
        }
        
        //controller callback
        func onStarted() {
            print("onStarted")
        }
        
        func onAuthenticationCompletion(_ result: (NSObjectProtocol & ActivationResultProtocol)!) {
            print("onAuthenticationCompletion", result);        
        }
        
        
    }
    
    class ContextCompletion: NSObject, StartServiceHandlerProtocol {
        var frm : OpenEcardProtocol? = nil;
        var eacFactory : EacControllerFactoryProtocol? = nil;
        var currentEacActivation: EacControllerStart? = nil;
        var currentController: ActivationControllerProtocol? = nil;
        var v: ViewController?
        var url : String?
      
        func setFrm(frm : OpenEcardProtocol){
            self.frm = frm;
        }
     
        func setViewCtrl(v:ViewController){
            self.v = v
        }

        func setURL(url: String){
            self.url = url

        }
        
        func onSuccess(_ source: (NSObjectProtocol & ActivationSourceProtocol)!) {
            print("Context process completed successfully.")
            
            self.eacFactory = source.eacFactory();
            self.currentEacActivation = EacControllerStart(frm: frm!, v:v!);
            
            
            
            self.currentController = self.eacFactory?.create(self.url, withActivation: currentEacActivation, with: currentEacActivation);
           
        }
        
        func onFailure(_ response: (NSObjectProtocol & ServiceErrorResponseProtocol)!) {
            print("Context process completed successfully.")
        }
    }
    
    lazy var frm = createOpenEcard()
    var ctxCompletion = ContextCompletion()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //	private static final String DEFAULT_TC_TOKEN_URL = "https://test.governikus-eid.de:443/Autent-DemoApplication/RequestServlet;?provider=demo_epa_20&redirect=true";
	    //  private static final String DEFAULT_TC_TOKEN_URL = "https://test.governikus-eid.de:443/Autent-DemoApplication/RequestServlet;?provider=demo_epa_can&redirect=true";
        //	private static final String DEFAULT_TC_TOKEN_URL = "https://service.dev.skidentity.de:443/tctoken";
        let serviceURL = "https://service.dev.skidentity.de:443/tctoken";
     //   tf2.setText(urlstart + serviceURL)
        tf2.text = serviceURL
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBOutlet weak var tf2: UITextView!
    
    @IBAction func defaultHandler(_ sender: UIButton) {
        print("Creating the context");
        let urlstart = "http://localhost/eID-Client?tcTokenURL="
        let context = frm?.context("Please provide card", withDefaultNFCCardRecognizedMessage: "Found card")
        ctxCompletion.setFrm(frm: frm!)
        ctxCompletion.setViewCtrl(v:self)
        ctxCompletion.setURL(url: urlstart + tf2.text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
        context?.start(ctxCompletion)
    }

    @IBAction func pinMgmt(_ sender: Any) {
    }
}
