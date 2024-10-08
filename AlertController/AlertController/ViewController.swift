import UIKit
import CoreNFC
import OpenEcard
import WebKit
import OpenEcard.open_ecard_mobile_lib

class ViewController: UIViewController, WKNavigationDelegate, UITextViewDelegate, URLSessionTaskDelegate {
    
    class IOSNFCOptions: NSObject, NFCConfigProtocol {
        func getProvideCardMessage() -> String! {
            return "Please hold card to your phone"
        }
        
        func getDefaultNFCCardRecognizedMessage() -> String! {
            return "Please wait. A card has been detected"
        }
        
        func getDefaultNFCErrorMessage() -> String! {
            return "An error occurred communicating with the card."
        }
        
        func getAquireNFCTagTimeoutMessage() -> String! {
            return "Could not connect to a card. Please try again."
        }
        
        func getNFCCompletionMessage() -> String! {
            return "Finished communicating with the card"
        }
        
        func getTagLostErrorMessage() -> String! {
            return "Contact was lost with the card"
        }
        
        func getDefaultCardConnectedMessage() -> String! {
            return "Connected with the card."
        }
        
        
    }
    
    class PinMgmtControllerStart: NSObject, ControllerCallbackProtocol, PinManagementInteractionProtocol{
       
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

        fileprivate func displayPinChangeable(_ message: String, _ enterOldNewPins: (NSObjectProtocol & ConfirmOldSetNewPasswordOperationProtocol)) {
            DispatchQueue.main.async{
                
                let alert = UIAlertController(title: "Enter old and new pin", message: message, preferredStyle: .alert)
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
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {[weak alert] (_) in
                    print("UI: cancelling")
                    self.ctxComp.cancelActivation()
                })
                
                let acceptAction = UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
                    guard let pin = alert?.textFields?[0], let npin = alert?.textFields?[1], let cnpin = alert?.textFields?[2] else {
                        print("UI: Issue with Alert TextFields")
                        return
                    }
                    
                    if(npin.text == cnpin.text){
                        enterOldNewPins.confirmPassword(pin.text, withNewPassword: npin.text)
                    }else{
                        print("UI: new pin and confirmation not equal")
                    }
                })
                
                alert.addAction(acceptAction)
                alert.addAction(cancelAction)
                
                self.v.present(alert, animated: true, completion: nil)
            }
        }
        
        func onPinChangeable(_ enterOldNewPins: (NSObjectProtocol & ConfirmOldSetNewPasswordOperationProtocol)!) {
            print("UI: onPinChangeable.");
            let message = "Pin attempts remaining (??)";
            displayPinChangeable(message, enterOldNewPins)
        }
        
        func onPinChangeable(_ attempts: Int32, withEnterOldNewPins enterOldNewPins: (NSObjectProtocol & ConfirmOldSetNewPasswordOperationProtocol)!) {
            print("UI: onPinChangeable. attempts: \(attempts)");
            let message = "Pin attempts remaining \(attempts)";
            displayPinChangeable(message, enterOldNewPins)
        }
        
        func onPinCanNewPinRequired(_ enterPinCanNewPin: (NSObjectProtocol & ConfirmPinCanNewPinOperationProtocol)!) {
            print("UI: onPinCanNewPinRequired")
            DispatchQueue.main.async{

                let alert = UIAlertController(title: "Enter current pin/can/new pin", message: "", preferredStyle: .alert)
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

                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {[weak alert] (_) in 
                    print("UI: cancelling")
                    self.ctxComp.cancelActivation()
                })
                let acceptAction = UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
                    guard let pin = alert?.textFields?[0], let can = alert?.textFields?[1], let newPin = alert?.textFields?[2], let cnpin = alert?.textFields?[3] else {
                        print("UI: Issue with Alert TextFields")
                        return
                    }

                    if(newPin.text == cnpin.text){
                        enterPinCanNewPin.confirmChangePassword(pin.text, withCan: can.text, withNewPin: newPin.text)
                    }else{
                        print("UI: new pin and confirmation not equal")
                    }
    

                })

                alert.addAction(acceptAction)
                alert.addAction(cancelAction)

                self.v.present(alert, animated: true, completion: nil)
            }
        }
        
        func onPinBlocked(_ unblockWithPuk: (NSObjectProtocol & ConfirmPasswordOperationProtocol)!) {
            print("UI: onPinBlocked");
            DispatchQueue.main.async{

                let alert = UIAlertController(title: "Enter puk", message: "", preferredStyle: .alert)
                alert.addTextField { (puk) in
                    puk.placeholder = "puk"
                    puk.isSecureTextEntry = true
                    puk.keyboardType = .numberPad
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {[weak alert] (_) in 
                    print("UI: cancelling")
                    self.ctxComp.cancelActivation()
                })
                let acceptAction = UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
                    guard let puk = alert?.textFields?[0] else {
                        print("UI: Issue with Alert TextFields")
                        return
                    }

                    unblockWithPuk.confirmPassword(puk.text)

                })

                alert.addAction(acceptAction)
                alert.addAction(cancelAction)

                self.v.present(alert, animated: true, completion: nil)
            }
        }
        
        func onCardPukBlocked() {
            print("UI: cardBlocked")
        }
        
        func onCardDeactivated() {
            print("UI: cardDeactivated")
        }
       
        func onStarted() {
            print("UI: onStarted");
        }
        
        func onAuthenticationCompletion(_ result: (NSObjectProtocol & ActivationResultProtocol)!) {
            print("UI: onAuthenticationCompletion: ", result);
            let code = result.getCode();
            print("UI: resultCode", code.rawValue)
            print("UI: resultMinor", result.getProcessResultMinor())
            if (code == ActivationResultCode.INTERRUPTED){
                print("UI: Interrupted")
            } else if (code == ActivationResultCode.INTERNAL_ERROR){
                print("UI: Internal error")
            } else {
                print("UI: Other")
            }
        }
        
        func requestCardInsertion() {
            print("UI: requestCardInsertion");
        }
        
        func requestCardInsertion(_ msgHandler: (NSObjectProtocol & NFCOverlayMessageHandlerProtocol)!) {
            print("UI: requestCardInsertion");
        }
        
        func onCardInteractionComplete() {
            print("UI: onCardInteractionComplete");
        }
        
        func onCardRecognized() {
            print("UI: onCardRecognized");
        }
        
        func onCardRemoved() {
            print("UI: onCardRemoved");
        }
    }
    
    class EacControllerStart: NSObject, ControllerCallbackProtocol, EacInteractionProtocol {
       
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
        
        fileprivate func showPinRequest(_ enterPin: (NSObjectProtocol & ConfirmPasswordOperationProtocol)?, message: String) {
            DispatchQueue.main.async{
                
                let alert = UIAlertController(title: "Enter pin", message: message, preferredStyle: .alert)
                alert.addTextField { (pin) in
                    pin.placeholder = "pin"
                    pin.isSecureTextEntry = true
                    pin.keyboardType = .numberPad
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {[weak alert] (_) in
                    print("UI: cancelling")
                    self.ctxComp.cancelActivation()
                })
                let acceptAction = UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
                    guard let pin = alert?.textFields?[0] else {
                        print("UI: Issue with Alert TextFields")
                        return
                    }
                    
                    enterPin!.confirmPassword(pin.text)
                    
                })
                
                alert.addAction(acceptAction)
                alert.addAction(cancelAction)
                
                self.v.present(alert, animated: true, completion: nil)
            }
        }
        
        func onPinRequest(_ enterPin: (NSObjectProtocol & ConfirmPasswordOperationProtocol)!) {
            print("UI: onPinRequest")
            
            showPinRequest(enterPin, message: "")
        }
        
        func onPinRequest(_ attempt: Int32, withEnterPin enterPin: (NSObjectProtocol & ConfirmPasswordOperationProtocol)!) {
            print("UI: onPinRequest with attempt")
            
            showPinRequest(enterPin, message: "Pin attempts remaining \(attempt)")
            
        }
        
        
        func requestCardInsertion() {
            print("UI: requestCardInsertion without handler ")
        }
        func requestCardInsertion(_ msgHandler: (NSObjectProtocol & NFCOverlayMessageHandlerProtocol)!) {
            self.msgHandler = msgHandler
            msgHandler.setText("Please provide the card now")
            print("UI: UI: requestCardInsertion with handler ")
        }
        
        func onPinCanRequest(_ enterPinCan: (NSObjectProtocol & ConfirmPinCanOperationProtocol)!) {
            print("UI: UI: onPinCanRequest")
            DispatchQueue.main.async{

                let alert = UIAlertController(title: "Enter pin/can", message: "", preferredStyle: .alert)
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

                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {[weak alert] (_) in 
                    print("UI: UI: cancelling")
                    self.ctxComp.cancelActivation()
                })
                let acceptAction = UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
                    guard let pin = alert?.textFields?[0], let can = alert?.textFields?[1] else {
                        print("UI: UI: Issue with Alert TextFields")
                        return
                    }

                    enterPinCan.confirmPassword(pin.text , withCan: can.text)
                    

                })

                alert.addAction(acceptAction)
                alert.addAction(cancelAction)

                self.v.present(alert, animated: true, completion: nil)
            }

        }

        func onCanRequest(_ enterCan: (NSObjectProtocol & ConfirmPasswordOperationProtocol)!) {
            print("UI: UI: onCanRequest")
            DispatchQueue.main.async{

                let alert = UIAlertController(title: "Enter can", message: "", preferredStyle: .alert)
                alert.addTextField { (can) in
                    can.placeholder = "can"
                    can.isSecureTextEntry = true
                    can.keyboardType = .numberPad
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {[weak alert] (_) in 
                    print("UI: UI: cancelling")
                    self.ctxComp.cancelActivation()
                })

                let acceptAction = UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
                    guard let can = alert?.textFields?[0] else {
                        print("UI: UI: Issue with Alert TextFields")
                        return
                    }
                   
                    enterCan.confirmPassword(can.text)
                })

                alert.addAction(acceptAction)
                alert.addAction(cancelAction)

                self.v.present(alert, animated: true, completion: nil)
            }
        }
        
        func onServerData(_ data: (NSObjectProtocol & ServerDataProtocol)!, withTransactionData transactionData: String!, withSelectReadWrite selectReadWrite: (NSObjectProtocol & ConfirmAttributeSelectionOperationProtocol)!) {
            print("UI: UI: onServerData")
            
            let duBytes = data.getTermsOfUsage()?.getDataBytes()  ?? Data.init()
            print(NSString.init(data: duBytes, encoding: String.Encoding.utf8.rawValue))

            DispatchQueue.main.async{
                let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert);

                var fieldCount = 0 
                var fieldHeight = 33

                var switches : [UISwitch] = Array()

                for itm in data.getReadAccessAttributes(){

                    let swtch = UISwitch(frame: CGRect(x: 0, y: fieldHeight * fieldCount, width: 250, height: 15))
                    let lbl = UILabel(frame: CGRect(x: 60, y: fieldHeight * fieldCount + 5, width: 250, height: 15))
                    lbl.text = itm.getText()
                    swtch.setOn(itm.isChecked(), animated: true)
                    switches.append(swtch)
                    fieldCount += 1
                    
                    alertController.view.addSubview(swtch)
                    alertController.view.addSubview(lbl)
                }

                var height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: CGFloat(fieldHeight*(2+fieldCount)))
                alertController.view.addConstraint(height);
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak alertController] (_) in
                    var idx = 0
                    for itm in data.getReadAccessAttributes(){
                            itm.setChecked(switches[idx].isOn)
                            idx += 1;
                        }

                    selectReadWrite.enterAttributeSelection(data.getReadAccessAttributes(), withWrite: nil)
 
                }))

                self.v.present(alertController, animated: true, completion: { () -> Void in })
            }

        }
        
        func onCardAuthenticationSuccessful() {
            self.msgHandler?.setText("Authentication to card successful")
            print("UI: UI: onCardAuthenticationSuccessful")
        }
        
        func onCardRecognized() {
            self.msgHandler?.setText("Card was detected")
            print("UI: UI: onCardRecognized")
        }
      
        func onCardBlocked() {
            print("UI: UI: onCardBlocked")
        }
        
        func onCardDeactivated() {
            print("UI: UI: onCardDeactivated")
        }
        
        func onCardInteractionComplete() {
            self.msgHandler?.setText("Card can soon be removed")
            print("UI: UI: onCardInteractionComplete2")
        }
        
        func onCardRemoved() {
            print("UI: UI: onCardRemoved");
        }
        
        func onStarted() {
            print("UI: UI: onStarted")
        }
        
        func onAuthenticationCompletion(_ result: (NSObjectProtocol & ActivationResultProtocol)!) {
            print("UI: UI: onAuthenticationCompletion", result);

            DispatchQueue.main.async{
                if let urlString = result.getRedirectUrl() {
                
                let url = URL(string: urlString)!
                print("UI: requesting url: \(urlString)")
                var request = URLRequest(url: url)
                    self.v.webView.load(request)
                    self.v.webView.isHidden = false 
                }else{
                    DispatchQueue.main.async{
                        let alert = UIAlertController(title: "Process end", message: "Process ended without redirect Message: \(result.getErrorMessage())", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {[weak alert] (_) in 
                            print("UI: cancelling")
                        })
                        alert.addAction(cancelAction)
                        self.v.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
   
    class ContextStop: NSObject, StopServiceHandlerProtocol {
        func onSuccess() {
            print("UI: StartServiceHandlerProtocol:onSuccess")
        }
        
        func onFailure(_ response: (NSObjectProtocol & ServiceErrorResponseProtocol)!) {
            print("UI: StartServiceHandlerProtocol:onFailure")
        }
        
        
    }
    
    class ContextCompletion: NSObject, StartServiceHandlerProtocol {
        var frm : OpenEcardProtocol? = nil;
        var eacFactory : EacControllerFactoryProtocol? = nil;
        var pinMgmtFactory : PinManagementControllerFactoryProtocol? = nil;
        var currentEacActivation: EacControllerStart? = nil;
        var currentPinMgmtActivation: PinMgmtControllerStart? = nil;
        var currentController: ActivationControllerProtocol? = nil;
        var source: ActivationSourceProtocol? = nil;
        var context: ContextManagerProtocol? = nil;
        var v: ViewController?
        var ready = false
      
        func setFrm(frm : OpenEcardProtocol){
            self.frm = frm;
        }
     
        func setConetxt(context: ContextManagerProtocol){
            self.context = context;
        }
        
        func setViewCtrl(v:ViewController){
            self.v = v
        }
        
        func onSuccess(_ source: (NSObjectProtocol & ActivationSourceProtocol)!) {
            print("UI: Context process completed successfully.")
            
            self.eacFactory = source.eacFactory();
            self.pinMgmtFactory = source.pinManagementFactory();
            self.source = source

            self.currentEacActivation = EacControllerStart(frm: frm!, v:v!, ctx:self);
            self.currentPinMgmtActivation = PinMgmtControllerStart(frm: frm!, v:v!, ctx: self);
            self.ready = true

            
        }

        func cancelActivation(){
            self.currentController?.cancelOngoingAuthentication()
        }

        func performEAC(url: String){
            if(self.ready){
                self.currentController = self.eacFactory?.create(url, withActivation: currentEacActivation, with: currentEacActivation);
            }
        }
           
        func performPINMgmt(){
            if(self.ready){
                self.currentController = self.pinMgmtFactory?.create(currentPinMgmtActivation, with: currentPinMgmtActivation); 
            }
        }
         
        func onFailure(_ response: (NSObjectProtocol & ServiceErrorResponseProtocol)!) {
            print("UI: Context process completed successfully.")
            self.ready = false 
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tf_directEACURL.text = "https://test.governikus-eid.de/Autent-DemoApplication/samlstationary";
        tf_testServerURL.text = "https://eid.mtg.de/eid-server-demo-app/index.html";
        
        self.webView.navigationDelegate = self
        self.webView.isHidden = true

        self.tf_directEACURL.delegate = self
        self.tf_directEACURL.backgroundColor = UIColor.init(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
        self.tf_testServerURL.delegate = self
        self.tf_testServerURL.backgroundColor = UIColor.init(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
        
        ini()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func ini(){
        print("UI: Creating the context");
        let context = frm?.context(IOSNFCOptions())
        context!.initializeContext(ctxCompletion)
        frm?.developerOptions()?.setDebugLogLevel()
        frm?.setDebugLogLevel()
        ctxCompletion.setFrm(frm: frm!)
        ctxCompletion.setConetxt(context: context!)
        // frm?.developerOptions()?.setDebugLogLevel()
        ctxCompletion.setViewCtrl(v:self)
    }
    
    
    @IBOutlet weak var tf_directEACURL: UITextView!
    @IBOutlet weak var tf_testServerURL: UITextView!

    
    lazy var frm = createOpenEcard()
    var ctxCompletion = ContextCompletion()
    
    @IBAction func eacDirectURL(_ sender: Any) {
        getTCTokenURL(url: tf_directEACURL.text) { tctokenurl in
            self.ctxCompletion.performEAC(url: tctokenurl)
        }
    }
    
    private func getTCTokenURL(url: String, hdlr: @escaping (String) -> Void) {

        let url = URL(string: url)!
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.httpBody =   "changeAllNatural=ALLOWED&requestedAttributesEidForm.documentType=ALLOWED&requestedAttributesEidForm.issuingState=ALLOWED&requestedAttributesEidForm.dateOfExpiry=ALLOWED&requestedAttributesEidForm.givenNames=ALLOWED&requestedAttributesEidForm.familyNames=ALLOWED&requestedAttributesEidForm.artisticName=ALLOWED&requestedAttributesEidForm.academicTitle=ALLOWED&requestedAttributesEidForm.dateOfBirth=ALLOWED&requestedAttributesEidForm.placeOfBirth=ALLOWED&requestedAttributesEidForm.nationality=ALLOWED&requestedAttributesEidForm.birthName=ALLOWED&requestedAttributesEidForm.placeOfResidence=ALLOWED&requestedAttributesEidForm.communityID=ALLOWED&requestedAttributesEidForm.residencePermitI=ALLOWED&requestedAttributesEidForm.restrictedId=ALLOWED&ageVerificationForm.ageToVerify=0&ageVerificationForm.ageVerification=PROHIBITED&placeVerificationForm.placeToVerify=02760401100000&placeVerificationForm.placeVerification=PROHIBITED&eidTypesForm.cardCertified=ALLOWED&eidTypesForm.seCertified=ALLOWED&eidTypesForm.seEndorsed=ALLOWED&eidTypesForm.hwKeyStore=ALLOWED&transactionInfo=&levelOfAssurance=BUND_HOCH".data(using: .utf8)

        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: request) {data,response,error in
            if let error = error {
                print("error: ")
                print(error)
            } else if let response = response as? HTTPURLResponse {
                print("response: ")
                print(response)
                if(response.statusCode == 302){
                    hdlr(response.value(forHTTPHeaderField: "Location") ?? "error")
                } else {
                    print("error")
                }
            } else {
                print("error")
            }
        }

        task.resume()
    }

   //stop redirect
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: (URLRequest?) -> Void) {
            print(request)
            completionHandler(nil)
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
                ctxCompletion.performEAC(url: navigationAction.request.url!.absoluteString)
                decisionHandler(.cancel)
                webView.isHidden = true
                return
            }

        decisionHandler(.allow)
        }

    }
}
