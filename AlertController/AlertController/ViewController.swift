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
                alert.addTextField { (pwd) in
                    pwd.placeholder = "pin/can"
                    pwd.isSecureTextEntry = true
                }

                //the cancel action doing nothing
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

                //the confirm action taking the inputs
                let acceptAction = UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
                    guard let pwd = alert?.textFields?[0] else {
                        print("Issue with Alert TextFields")
                        return
                    }

                    DispatchQueue.global(qos: .background).async{
                        enterPin.enter(pwd.text)
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
        }

        func onCanRequest(_ enterCan: (NSObjectProtocol & ConfirmPasswordOperationProtocol)!) {
            print("onCanRequest")

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
      
        func setFrm(frm : OpenEcardProtocol){
            self.frm = frm;
        }
     
        func setViewCtrl(v:ViewController){
            self.v = v
        }
        
        func onSuccess(_ source: (NSObjectProtocol & ActivationSourceProtocol)!) {
            print("Context process completed successfully.")
            
            self.eacFactory = source.eacFactory();
            self.currentEacActivation = EacControllerStart(frm: frm!, v:v!);
            
            
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

        //	private static final String DEFAULT_TC_TOKEN_URL = "https://test.governikus-eid.de:443/Autent-DemoApplication/RequestServlet;?provider=demo_epa_20&redirect=true";
	    //  private static final String DEFAULT_TC_TOKEN_URL = "https://test.governikus-eid.de:443/Autent-DemoApplication/RequestServlet;?provider=demo_epa_can&redirect=true";
        //	private static final String DEFAULT_TC_TOKEN_URL = "https://service.dev.skidentity.de:443/tctoken";
        let urlstart = "http://localhost/eID-Client?tcTokenURL="
        let serviceURL = "https://service.dev.skidentity.de:443/tctoken";
     //   tf2.setText(urlstart + serviceURL)
        tf2.text = urlstart+serviceURL
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBOutlet weak var tf2: UITextView!
    
    @IBAction func defaultHandler(_ sender: UIButton) {
        print("Creating the context");
        let context = frm?.context("Please provide card", withDefaultNFCCardRecognizedMessage: "Found card")
        ctxCompletion.setFrm(frm: frm!)
        ctxCompletion.setViewCtrl(v:self)
        context?.start(ctxCompletion)
    }

    func showInputDia(_ what: String){
        let alert = UIAlertController(title: "Enter \(what)", message: "", preferredStyle: .alert)
                   //Add the text field. You can configure it however you need.
        alert.addTextField { (pwd) in
            pwd.placeholder = "pin/can"
            pwd.isSecureTextEntry = true
        }

        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        //the confirm action taking the inputs
        let acceptAction = UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
            guard let pwd = alert?.textFields?[0] else {
                print("Issue with Alert TextFields")
                return
            }

            print("Text field: \(pwd)")

        })

        //adding the actions to alertController
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)

        // Presenting the alert
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func pinMgmt(_ sender: Any) {
        showInputDia("hi")
    }
}
