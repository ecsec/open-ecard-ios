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
        init(frm : OpenEcardProtocol) {
            self.frm = frm;
            self.msgHandler = nil;
            super.init()
        }
 
        func onCanRequest(_ enterCan: (NSObjectProtocol & ConfirmPasswordOperationProtocol)!) {
            
        }
        
        func onServerData(_ data: (NSObjectProtocol & ServerDataProtocol)!, withTransactionData transactionData: String!, withSelectReadWrite selectReadWrite: (NSObjectProtocol & ConfirmAttributeSelectionOperationProtocol)!) {
            msgHandler?.setText("Allowing attributes automatically")
            selectReadWrite.enter(data as? [NSObjectProtocol & SelectableItemProtocol], withWrite: nil)
        }
        
        func onCardAuthenticationSuccessful() {
            
        }
        
        func onCardRecognized() {
            print("on card recognized the wrong one")
        }
        
        func onCardRecognized(_ msgHandler: (NSObjectProtocol & NFCOverlayMessageHandlerProtocol)!) {
            print("on card recognized ")
            msgHandler?.setText("card recognized")
            self.msgHandler = msgHandler;
        }
       
        func onPinRequest(_ attempt: Int32, withEnterPin enterPin: (NSObjectProtocol & ConfirmPasswordOperationProtocol)!) {
            let pin = "123123"
            msgHandler?.setText("Entering pin: \(pin)")
            enterPin.enter(pin)
        }
        
        func onPinCanRequest(_ enterPinCan: (NSObjectProtocol & ConfirmTwoPasswordsOperationProtocol)!) {
                print("onPinCanRequest");
        }
        
        func onCardBlocked() {
            print("blocked")
        }
        
        func onCardDeactivated() {
            
        }
        
        func onCardInteractionComplete() {
            print("onCardInteractionComplete")
        }
        func onTransactionInfo(_ data: String!) {
            print("onTransactionInfo");
        }
        
        func onInteractionComplete() {
            print("onInteractionComplete");
        }
        
        func requestCardInsertion() {
            DispatchQueue.global(qos: .userInitiated).async {
                self.frm.triggerNFC()
            }
            
        }
        
        func onCardRemoved() {
            print("onCardRemoved");
        }
        


        //controller callback
        func onStarted() {
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
       
      
        func setFrm(frm : OpenEcardProtocol){
            self.frm = frm;
        }
        
        func onSuccess(_ source: (NSObjectProtocol & ActivationSourceProtocol)!) {
            print("Context process completed successfully.")
            
            self.eacFactory = source.eacFactory();
            self.currentEacActivation = EacControllerStart(frm: frm!);
            let baseUrl = "http://localhost/eID-Client?tcTokenURL="
            let tcTokenUrl = "https%3A%2F%2Ftest.governikus-eid.de%3A443%2FAutent-DemoApplication%2FRequestServlet%3B%3Fprovider%3Ddemo_epa_20%26redirect%3Dtrue"
            self.currentController = self.eacFactory?.create(baseUrl + tcTokenUrl, withActivation: currentEacActivation, with: currentEacActivation);
           
        }
        
        func onFailure(_ response: (NSObjectProtocol & ServiceErrorResponseProtocol)!) {
            print("Context process completed successfully.")
        }
    }
    
    lazy var frm = createOpenEcard()
    var ctxCompletion = ContextCompletion()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBOutlet weak var tf2: UITextView!
    
    @IBAction func defaultHandler(_ sender: UIButton) {
        print("Creating the context");
        let context = frm?.context("Please provide card", withDefaultNFCCardRecognizedMessage: "Found card")
        ctxCompletion.setFrm(frm: frm!)
        context?.start(ctxCompletion)
    }

    @IBAction func pinMgmt(_ sender: Any) {
    }
}
