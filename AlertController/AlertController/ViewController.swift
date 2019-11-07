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
        func onCanRequest(_ enterCan: (NSObjectProtocol & ConfirmPasswordOperationProtocol)!) {
            
        }
        
        func onServerData(_ data: (NSObjectProtocol & ServerDataProtocol)!, withTransactionData transactionData: String!, withSelectReadWrite selectReadWrite: (NSObjectProtocol & ConfirmAttributeSelectionOperationProtocol)!) {
            
        }
        
        func onCardAuthenticationSuccessful() {
            
        }
        
        func onCardInteractionComplete() {
            
        }
        
        func onCardRecognized() {
            print("on card recognized the wrong one")
        }
        
        func onCardRecognized(_ msgHandler: (NSObjectProtocol & NFCOverlayMessageHandlerProtocol)!) {
            print("on card recognized ")
            msgHandler.setText("card recognized")
            
        }
        
        
        let frm : OpenEcardProtocol;
        init(frm : OpenEcardProtocol) {
            self.frm = frm;
            super.init()
        }
        
        func onPinRequest(_ attempt: Int32, withEnterPin enterPin: (NSObjectProtocol & ConfirmPasswordOperationProtocol)!) {
            print("onPinRequest");
            enterPin.enter("123456")
        }
        
        func onPinCanRequest(_ enterPinCan: (NSObjectProtocol & ConfirmTwoPasswordsOperationProtocol)!) {
                print("onPinCanRequest");
        }
        
        func onCardBlocked() {
            print("blocked")
        }
        
        func onCardDeactivated() {
            
        }
        
        func onServerData(_ data: (NSObjectProtocol & ServerDataProtocol)!, withSelectReadWrite selectReadWrite: (NSObjectProtocol & ConfirmAttributeSelectionOperationProtocol)!) {
            
            print("onServerData");
        }
        
        func onTransactionInfo(_ data: String!) {
            
            print("onTransactionInfo");
        }
        
       
        
        func onInteractionComplete() {
            
            print("onInteractionComplete");
        }
        
        func requestCardInsertion() {
            
            print("requestCardInsertion");
        }
        
        func onCardRemoved() {
            print("onCardRemoved");
        }
        
        func onStarted() {
            print("onStarted");
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.frm.triggerNFC()
            }
        }
        
        func onAuthenticationCompletion(_ result: (NSObjectProtocol & ActivationResultProtocol)!) {
            print("onAuthenticationCompletion", result);        }
        
        
    }
    
    class ContextCompletion: NSObject, StartServiceHandlerProtocol {
        var frm : OpenEcardProtocol? = nil;
        var eacFactory : EacControllerFactoryProtocol? = nil;
        var currentEacActivation: EacControllerStart? = nil;
        var currentController: ActivationControllerProtocol? = nil;
       
        override init(){
        }
        
      
        func setFrm(frm : OpenEcardProtocol){
            self.frm = frm;
        }
        
        func onSuccess(_ source: (NSObjectProtocol & ActivationSourceProtocol)!) {
            print("Context process completed successfully.")
            
            self.eacFactory = source.eacFactory();
            self.currentEacActivation = EacControllerStart(frm: frm!);
            print(eacFactory);
            let baseUrl = "http://localhost/eID-Client?tcTokenURL="
            let tcTokenUrl = "https%3A%2F%2Ftest.governikus-eid.de%3A443%2FAutent-DemoApplication%2FRequestServlet%3B%3Fprovider%3Ddemo_epa_20%26redirect%3Dtrue"
            self.currentController = self.eacFactory?.create(baseUrl + tcTokenUrl, withActivation: currentEacActivation, with: currentEacActivation);
            
            // DispatchQueue.global(qos: .userInitiated).async {
            //self.currentController?.start()
            // }
            
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
        
       doSomethingWithOpeneCard()
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
        print("Creating the framework");
        self.frm = createOpenEcard()
        
        print(frm)
        print("Creating the context");
        let context = frm?.context("a", withDefaultNFCCardRecognizedMessage: "b")
        print("Printing the contex");
        print(context)
        
        helper.setFrm(frm: frm!)
        
        print("Starting the openecard framework");
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
