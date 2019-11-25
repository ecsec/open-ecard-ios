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
    class PinMgmtControllerStart: NSObject, ControllerCallbackProtocol, PinManagementInteractionProtocol{
        func onCardPukBlocked() {
            print("cardBlocked")
        }
        
        func onCardDeactivated() {
            print("cardDeactivated")
        }
        
        
        let frm : OpenEcardProtocol;
        var msgHandler : NFCOverlayMessageHandlerProtocol?;
        var v :ViewController

        init(frm : OpenEcardProtocol, v:ViewController) {
            self.v = v
            self.frm = frm
            self.msgHandler = nil
            super.init()
        }


        func onPinChangeable(_ attempts: Int32, withEnterOldNewPins enterOldNewPins: (NSObjectProtocol & ConfirmOldSetNewPasswordOperationProtocol)!) {
            print("onPinChangeable. attempts: \(attempts)");
            DispatchQueue.main.async{

                let alert = UIAlertController(title: "Enter old and new pin", message: "Pin attempts remaining \(attempts)", preferredStyle: .alert)
                           //Add the text field. You can configure it however you need.
                alert.addTextField { (pin) in
                    pin.placeholder = "pin"
                    pin.isSecureTextEntry = true
                }
                alert.addTextField { (npin) in
                    npin.placeholder = "new pin"
                    npin.isSecureTextEntry = true
                }
                alert.addTextField { (cnpin) in
                    cnpin.placeholder = "confirm new pin"
                    cnpin.isSecureTextEntry = true
                }

                //the cancel action doing nothing
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

                //the confirm action taking the inputs
                let acceptAction = UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
                    guard let pin = alert?.textFields?[0], let npin = alert?.textFields?[1], let cnpin = alert?.textFields?[2] else {
                        print("Issue with Alert TextFields")
                        return
                    }

                    if(npin.text == cnpin.text){
                        enterOldNewPins.enter(pin.text, withNewPassword: npin.text)
                    }else{
                        print("new pin and confirmation not equal")
                    }
                    

                })

                //adding the actions to alertController
                alert.addAction(acceptAction)
                alert.addAction(cancelAction)

                // Presenting the alert
                self.v.present(alert, animated: true, completion: nil)
            }

        }
        
        func onPinCanRequired(_ enterPinCan: (NSObjectProtocol & ConfirmPinCanOperationProtocol)!) {
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

                    enterPinCan.enter(pin.text, withCan: can.text)
                    

                })

                //adding the actions to alertController
                alert.addAction(acceptAction)
                alert.addAction(cancelAction)

                // Presenting the alert
                self.v.present(alert, animated: true, completion: nil)
            }
        }
        
        func onPinBlocked(_ unblockWithPuk: (NSObjectProtocol & ConfirmPasswordOperationProtocol)!) {
            print("onPinBlocked");
            DispatchQueue.main.async{

                let alert = UIAlertController(title: "Enter puk", message: "", preferredStyle: .alert)
                           //Add the text field. You puk configure it however you need.
                alert.addTextField { (puk) in
                    puk.placeholder = "puk"
                    puk.isSecureTextEntry = true
                }

                //the cancel action doing nothing
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

                //the confirm action taking the inputs
                let acceptAction = UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
                    guard let puk = alert?.textFields?[1] else {
                        print("Issue with Alert TextFields")
                        return
                    }

                    unblockWithPuk.enter(puk.text)
                    

                })

                //adding the actions to alertController
                alert.addAction(acceptAction)
                alert.addAction(cancelAction)

                // Presenting the alert
                self.v.present(alert, animated: true, completion: nil)
            }
        }
       
        func onStarted() {
            print("onStarted");
        }
        
        func onAuthenticationCompletion(_ result: (NSObjectProtocol & ActivationResultProtocol)!) {
            print("onAuthenticationCompletion");
        }
        
        func requestCardInsertion() {
            print("requestCardInsertion");
        }
        
        func requestCardInsertion(_ msgHandler: (NSObjectProtocol & NFCOverlayMessageHandlerProtocol)!) {
            print("requestCardInsertion");
        }
        
        func onCardInteractionComplete() {
            print("onCardInteractionComplete");
        }
        
        func onCardRecognized() {
            print("onCardRecognized");
        }
        
        func onCardRemoved() {
            print("onCardRemoved");
        }
        
                
    }
    
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
            print("requestCardInsertion without handler ")
        }
        func requestCardInsertion(_ msgHandler: (NSObjectProtocol & NFCOverlayMessageHandlerProtocol)!) {
            self.msgHandler = msgHandler
            msgHandler.setText("Please provide the card now")
            print("requestCardInsertion with handler ")
        }
        
        func onPinRequest(_ attempt: Int32, withEnterPin enterPin: (NSObjectProtocol & ConfirmPasswordOperationProtocol)!) {
            print("onPinRequest")

            DispatchQueue.main.async{

                let alert = UIAlertController(title: "Enter pin", message: "", preferredStyle: .alert)
                           //Add the text field. You can configure it however you need.
                alert.addTextField { (pin) in
                    pin.placeholder = "pin"
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

                    enterPin.enter(pin.text)

                })

                //adding the actions to alertController
                alert.addAction(acceptAction)
                alert.addAction(cancelAction)

                // Presenting the alert
                self.v.present(alert, animated: true, completion: nil)
            }
        }

        func onPinCanRequest(_ enterPinCan: (NSObjectProtocol & ConfirmPinCanOperationProtocol)!) {
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

                    enterPinCan.enter(pin.text , withCan: can.text)
                    

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

                   
                    enterCan.enter(can.text)
                    

                })

                //adding the actions to alertController
                alert.addAction(acceptAction)
                alert.addAction(cancelAction)

                // Presenting the alert
                self.v.present(alert, animated: true, completion: nil)
            }
        }
        
        func onServerData(_ data: (NSObjectProtocol & ServerDataProtocol)!, withTransactionData transactionData: String!, withSelectReadWrite selectReadWrite: (NSObjectProtocol & ConfirmAttributeSelectionOperationProtocol)!) {
            print("onServerData")

            var msg = ""
            for itm in data.getReadAccessAttributes(){
                msg += itm.getText() + ", "
            }

            DispatchQueue.main.async{

                let alert = UIAlertController(title: "Allow acces for", message: msg, preferredStyle: .alert)
                //the cancel action doing nothing
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

                //the confirm action taking the inputs
                let acceptAction = UIAlertAction(title: "Allow", style: .default, handler: { [weak alert] (_) in
                    selectReadWrite.enter(data as? [NSObjectProtocol & SelectableItemProtocol], withWrite: nil)
                })

                //adding the actions to alertController
                alert.addAction(acceptAction)
                alert.addAction(cancelAction)

                // Presenting the alert
                self.v.present(alert, animated: true, completion: nil)
            }
        }
        
        func onCardAuthenticationSuccessful() {
            self.msgHandler?.setText("Authentication to card successful")
            print("onCardAuthenticationSuccessful")
        }
        
        func onCardRecognized() {
            self.msgHandler?.setText("Card was detected")
            print("on card recognized")
        }
      
        func onCardBlocked() {
            print("onCardBlocked")
        }
        
        func onCardDeactivated() {
            print("onCardDeactivated")
        }
        
        func onCardInteractionComplete() {
            self.msgHandler?.setText("Card can soon be removed")
            print("onCardInteractionComplete")
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

            if(result.getCode()==ActivationResultCode.REDIRECT){
            let url = URL(string: result.getRedirectUrl() as! String)!
            var request = URLRequest(url: url)
            request.httpMethod = "GET" 
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {(response, data, error) in
                guard let data = data else { return }
                print(String(data: data, encoding: .utf8)!)
                }
            
            }
        }
        
        
    }
   
    class ContextCompletion: NSObject, StartServiceHandlerProtocol {
        var frm : OpenEcardProtocol? = nil;
        var eacFactory : EacControllerFactoryProtocol? = nil;
        var pinMgmtFactory : PinManagementControllerFactoryProtocol? = nil;
        var currentEacActivation: EacControllerStart? = nil;
        var currentPinMgmtActivation: PinMgmtControllerStart? = nil;
        var currentController: ActivationControllerProtocol? = nil;
        var v: ViewController?
        var url : String?
        var ready = false
      
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
            self.pinMgmtFactory = source.pinManagementFactory();

            self.currentEacActivation = EacControllerStart(frm: frm!, v:v!);
            self.currentPinMgmtActivation = PinMgmtControllerStart(frm: frm!, v:v!);
            self.ready = true

            
        }

        func performEAC(){
            if(self.ready){
                self.currentController = self.eacFactory?.create(self.url, withActivation: currentEacActivation, with: currentEacActivation);
            }
        }
           
        func performPINMgmt(){
            if(self.ready){
                self.currentController = self.pinMgmtFactory?.create(currentPinMgmtActivation, with: currentPinMgmtActivation); 
            }
        }
         
        func onFailure(_ response: (NSObjectProtocol & ServiceErrorResponseProtocol)!) {
            print("Context process completed successfully.")
            self.ready = false 
        }
    }
    
    lazy var frm = createOpenEcard()
    var ctxCompletion = ContextCompletion()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let serviceURL_1 = "https://test.governikus-eid.de:443/Autent-DemoApplication/RequestServlet;?provider=demo_epa_20&redirect=true";
	    let serviceURL_2 = "https://test.governikus-eid.de:443/Autent-DemoApplication/RequestServlet;?provider=demo_epa_can&redirect=true";
      	let serviceURL_3 = "https://service.dev.skidentity.de:443/tctoken";
        let serviceURL_4 = "http://127.0.0.1:24727/eID-Client?cardTypes=http%3A%2F%2Fbsi.bund.de%2Fcif%2Fnpa.xml&tcTokenURL=https%3A%2F%2Fservice.skidentity-test.de%2Fbackend%2Ftr03130%2Factivate-client%3Fsession%3DdLNNLJ7Oy7BEXnnOciqvzw%26type%3Dhttp%253A%252F%252Fbsi.bund.de%252Fcif%252Fnpa.xml%26protocol%3Durn%253Aoid%253A1.3.162.15480.3.0.14%26activation-type%3DeID-Client"
        let serviceURL_5 = "https://service.skidentity-test.de/backend/tr03130/activate-client?session=dLNNLJ7Oy7BEXnnOciqvzw"

        tf2.text = serviceURL_3

        ini()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    
    func ini(){
        print("Creating the context");
        var context = frm?.context("Please provide card", withDefaultNFCCardRecognizedMessage: "Found card")
        context?.start(ctxCompletion)
        let urlstart = "http://localhost/eID-Client?tcTokenURL="
        ctxCompletion.setFrm(frm: frm!)
        ctxCompletion.setViewCtrl(v:self)
        ctxCompletion.setURL(url: urlstart + frm!.prepareTCTokenURL(tf2.text))
    }

    @IBOutlet weak var tf2: UITextView!
    
    @IBAction func defaultHandler(_ sender: UIButton) {
        ctxCompletion.performEAC()
    }

    @IBAction func pinMgmt(_ sender: Any) {
        ctxCompletion.performPINMgmt()
    }
}
