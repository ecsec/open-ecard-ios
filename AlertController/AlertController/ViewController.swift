import UIKit
import CoreNFC
import OpenEcard
import WebKit
import OpenEcard.open_ecard_mobile_lib

class ViewController: UIViewController, WKNavigationDelegate {
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
        var ctxComp :ContextCompletion;

        init(frm : OpenEcardProtocol, v:ViewController, ctx: ContextCompletion) {
            self.v = v
            self.frm = frm
            self.msgHandler = nil
            self.ctxComp = ctx
            super.init()
        }


        func onPinChangeable(_ attempts: Int32, withEnterOldNewPins enterOldNewPins: (NSObjectProtocol & ConfirmOldSetNewPasswordOperationProtocol)!) {
            print("onPinChangeable. attempts: \(attempts)");
            DispatchQueue.main.async{

                let alert = UIAlertController(title: "Enter old and new pin", message: "Pin attempts remaining \(attempts)", preferredStyle: .alert)
                           //Add the text field. You can configure it however you need.
                alert.addTextField { (pin) in
                    pin.placeholder = "pin"
                    pin.keyboardType = .numberPad
                    pin.isSecureTextEntry = true
                }
                alert.addTextField { (npin) in
                    npin.placeholder = "new pin"
                    npin.keyboardType = .numberPad
                    npin.isSecureTextEntry = true
                }
                alert.addTextField { (cnpin) in
                    cnpin.placeholder = "confirm new pin"
                    cnpin.isSecureTextEntry = true
                    cnpin.keyboardType = .numberPad
                }

                //the cancel action doing nothing
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {[weak alert] (_) in 
                    print("cancelling")
                    self.ctxComp.cancelActivation()
                })

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
        
        func onPinCanNewPinRequired(_ enterPinCanNewPin: (NSObjectProtocol & ConfirmPinCanNewPinOperationProtocol)!) {
            print("onPinCanNewPinRequired")
            DispatchQueue.main.async{

                let alert = UIAlertController(title: "Enter current pin/can/new pin", message: "", preferredStyle: .alert)
                           //Add the text field. You can configure it however you need.
                alert.addTextField { (pin) in
                    pin.placeholder = "pin"
                    pin.isSecureTextEntry = true
                    pin.keyboardType = .numberPad
                }
                alert.addTextField { (can) in
                    can.placeholder = "can"
                    can.isSecureTextEntry = true
                    can.keyboardType = .numberPad
                }
                alert.addTextField { (newPin) in
                    newPin.placeholder = "new pin"
                    newPin.isSecureTextEntry = true
                    newPin.keyboardType = .numberPad
                }
                alert.addTextField { (cnpin) in
                    cnpin.placeholder = "confirm new pin"
                    cnpin.isSecureTextEntry = true
                    cnpin.keyboardType = .numberPad
                }



                //the cancel action doing nothing
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {[weak alert] (_) in 
                    print("cancelling")
                    self.ctxComp.cancelActivation()
                })
                //the confirm action taking the inputs
                let acceptAction = UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
                    guard let pin = alert?.textFields?[0], let can = alert?.textFields?[1], let newPin = alert?.textFields?[2], let cnpin = alert?.textFields?[3] else {
                        print("Issue with Alert TextFields")
                        return
                    }

                    if(newPin.text == cnpin.text){
                        enterPinCanNewPin.enter(pin.text, withCan: can.text, withNewPin: newPin.text)
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
        
        func onPinBlocked(_ unblockWithPuk: (NSObjectProtocol & ConfirmPasswordOperationProtocol)!) {
            print("onPinBlocked");
            DispatchQueue.main.async{

                let alert = UIAlertController(title: "Enter puk", message: "", preferredStyle: .alert)
                           //Add the text field. You puk configure it however you need.
                alert.addTextField { (puk) in
                    puk.placeholder = "puk"
                    puk.isSecureTextEntry = true
                    puk.keyboardType = .numberPad
                }

                //the cancel action doing nothing
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {[weak alert] (_) in 
                    print("cancelling")
                    self.ctxComp.cancelActivation()
                })
                //the confirm action taking the inputs
                let acceptAction = UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
                    guard let puk = alert?.textFields?[0] else {
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
        fileprivate func showPinRequest(_ enterPin: (NSObjectProtocol & ConfirmPasswordOperationProtocol)?, message: String) {
            DispatchQueue.main.async{
                
                let alert = UIAlertController(title: "Enter pin", message: message, preferredStyle: .alert)
                //Add the text field. You can configure it however you need.
                alert.addTextField { (pin) in
                    pin.placeholder = "pin"
                    pin.isSecureTextEntry = true
                    pin.keyboardType = .numberPad
                }
                
                //the cancel action doing nothing
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {[weak alert] (_) in
                    print("cancelling")
                    self.ctxComp.cancelActivation()
                })
                //the confirm action taking the inputs
                let acceptAction = UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
                    guard let pin = alert?.textFields?[0] else {
                        print("Issue with Alert TextFields")
                        return
                    }
                    
                    enterPin!.enter(pin.text)
                    
                })
                
                //adding the actions to alertController
                alert.addAction(acceptAction)
                alert.addAction(cancelAction)
                
                // Presenting the alert
                self.v.present(alert, animated: true, completion: nil)
            }
        }
        
        func onPinRequest(_ enterPin: (NSObjectProtocol & ConfirmPasswordOperationProtocol)!) {
            print("onPinRequest")
            
            showPinRequest(enterPin, message: "")
        }
        
        func onPinRequest(_ attempt: Int32, withEnterPin enterPin: (NSObjectProtocol & ConfirmPasswordOperationProtocol)!) {
            print("onPinRequest with attempt")
            
            showPinRequest(enterPin, message: "Pin attempts remaining \(attempt)")
            
        }

        
        let frm : OpenEcardProtocol;
        var msgHandler : NFCOverlayMessageHandlerProtocol?;
        var v :ViewController
        var ctxComp : ContextCompletion
        
        init(frm : OpenEcardProtocol, v:ViewController, ctx: ContextCompletion) {
            self.v = v
            self.frm = frm
            self.msgHandler = nil
            self.ctxComp = ctx
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
        
        func onPinCanRequest(_ enterPinCan: (NSObjectProtocol & ConfirmPinCanOperationProtocol)!) {
            print("onPinCanRequest")
            DispatchQueue.main.async{

                let alert = UIAlertController(title: "Enter pin/can", message: "", preferredStyle: .alert)
                           //Add the text field. You can configure it however you need.
                alert.addTextField { (pin) in
                    pin.placeholder = "pin"
                    pin.isSecureTextEntry = true
                    pin.keyboardType = .numberPad
                }
                alert.addTextField { (can) in
                    can.placeholder = "can"
                    can.isSecureTextEntry = true
                    can.keyboardType = .numberPad
                }

                //the cancel action doing nothing
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {[weak alert] (_) in 
                    print("cancelling")
                    self.ctxComp.cancelActivation()
                })
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
                    can.keyboardType = .numberPad
                }

                //the cancel action doing nothing
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {[weak alert] (_) in 
                    print("cancelling")
                    self.ctxComp.cancelActivation()
                })

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
            
            let duBytes = data.getTermsOfUsage()?.getDataBytes()  ?? Data.init()
            print(NSString.init(data: duBytes, encoding: String.Encoding.utf8.rawValue))

            selectReadWrite.enter(data.getReadAccessAttributes(), withWrite: nil)
//            DispatchQueue.main.async{
//                //simple alert dialog
//                let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert);
////                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil));
//
//                var fieldCount = 0 
//                var fieldHeight = 33
//
//                var switches : [UISwitch] = Array()
//
//                for itm in data.getReadAccessAttributes(){
//
//                    let swtch = UISwitch(frame: CGRect(x: 0, y: fieldHeight * fieldCount, width: 250, height: 15))
//                    let lbl = UILabel(frame: CGRect(x: 60, y: fieldHeight * fieldCount + 5, width: 250, height: 15))
//                    lbl.text = itm.getText()
//                    swtch.setOn(itm.isChecked(), animated: true)
//                    switches.append(swtch)
//                    fieldCount += 1
//                    
//                    alertController.view.addSubview(swtch)
//                    alertController.view.addSubview(lbl)
//                }
//
//                var height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(fieldHeight*(2+fieldCount)))
//                alertController.view.addConstraint(height);
//                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak alertController] (_) in
//                    var idx = 0
//                    for itm in data.getReadAccessAttributes(){
//                            itm.setChecked(switches[idx].isOn)
//                            idx += 1;
//                        }
//
//                    selectReadWrite.enter(data.getReadAccessAttributes(), withWrite: nil)
// 
//                }))
//
//                self.v.present(alertController, animated: true, completion: { () -> Void in })
//            }

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

            DispatchQueue.main.async{
                if let urlString = result.getRedirectUrl() {
                
                let url = URL(string: urlString)!
                print("requesting url: \(urlString)")
                var request = URLRequest(url: url)
                    self.v.webView.load(request)
                    self.v.webView.isHidden = false
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

            self.currentEacActivation = EacControllerStart(frm: frm!, v:v!, ctx:self);
            self.currentPinMgmtActivation = PinMgmtControllerStart(frm: frm!, v:v!, ctx: self);
            self.ready = true

            
        }

        func cancelActivation(){
            self.currentController?.cancelAuthentication()
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
        
        //tf_directEACURL.text = "https://test.governikus-eid.de:443/Autent-DemoApplication/RequestServlet;?provider=demo_epa_20&redirect=true";
        tf_directEACURL.text = "https://service.dev.skidentity.de:443/tctoken";
        tf_testServerURL.text = "https://service.dev.skidentity.de:443";
        
        self.webView.navigationDelegate = self
        self.webView.isHidden = true


        self.tf_directEACURL.backgroundColor = UIColor.init(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
        self.tf_testServerURL.backgroundColor = UIColor.init(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
        
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
        ctxCompletion.setURL(url: urlstart + frm!.prepareTCTokenURL(tf_directEACURL.text))
    }
    
    
    @IBOutlet weak var tf_directEACURL: UITextView!
    
    @IBOutlet weak var tf_testServerURL: UITextView!

    
    @IBAction func eacDirectURL(_ sender: Any) {
        ctxCompletion.performEAC()
    }
    
    @IBAction func eacWithServer(_ sender: Any) {
        guard let url = URL(string: tf_testServerURL.text) else { return }
        let req = URLRequest(url: url)
        self.webView.load(req)
        self.webView.isHidden = false
    }
    
    
    @IBAction func pinMgmt(_ sender: Any) {
        ctxCompletion.performPINMgmt()
    }
    
    @IBOutlet var webView: WKWebView!
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        var scriptContent = "var meta = document.createElement('meta');"
        scriptContent += "meta.name='viewport';"
        scriptContent += "meta.content='width=device-width';"
        scriptContent += "document.getElementsByTagName('head')[0].appendChild(meta);"
        
        webView.evaluateJavaScript(scriptContent, completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        
        self.webView.scrollView.zoomScale = 6
        
        if let host = navigationAction.request.url?.host {
            if host.contains("localhost") || host.contains("127.0.0.1") {
                ctxCompletion.setURL(url: navigationAction.request.url!.absoluteString)
                ctxCompletion.performEAC()
                decisionHandler(.cancel)
                webView.isHidden = true
                return
            }

        decisionHandler(.allow)
        }

    }
}
