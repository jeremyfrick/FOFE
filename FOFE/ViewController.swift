//
//  ViewController.swift
//  FOFE
//
//  Created by Jeremy Frick on 5/27/15.
//  Copyright (c) 2015 Red Anchor Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var toTextBox: UITextField!
    @IBOutlet weak var fromTextBox: UITextField!
    @IBOutlet weak var foButton: UIButton!
    @IBOutlet weak var foTextLabel: UILabel!
    @IBOutlet weak var yellItSwitch: UISwitch!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareFOButton: UIBarButtonItem!
    @IBOutlet weak var cleanItUpSwitch: UISwitch!
    
    lazy var toText = String()
    lazy var fromText = String()
    let message = FOMessage()
    let parser = parseJsonData()
    lazy var bURL = BuildURL()
    lazy var cleanMessage = CleanItUp()
    var keyboardIsShowing: Bool!
    var keyboardFrame: CGRect!
    var kPreferredTextFieldToKeyboardOffset: CGFloat = 20.0
    var activeTextView:UIView!
    var dirtyMessage = String()
    var newMessage = String()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.yellItSwitch.on = false
        self.cleanItUpSwitch.on = false
        toTextBox.delegate = self
        fromTextBox.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func foButtonPressed(sender: AnyObject) {
        toText = self.toTextBox.text
        fromText = self.fromTextBox.text
       buildMessage(toText, from: fromText)
        
    }
    
    @IBAction func cleanItUpSwitchChange(sender: AnyObject) {
        if (self.cleanItUpSwitch.on && self.foTextLabel.text != "") {
            self.newMessage = self.cleanMessage.cleanUpMessage(self.dirtyMessage)
            self.foTextLabel.text = newMessage
        }else {
            self.foTextLabel.text = dirtyMessage
        }
    }
    
    
    func buildMessage(to: String, from: String) {
        
        
            let url = bURL.buildUrl(to, from: from, yell: self.yellItSwitch.on)
            let request = NSMutableURLRequest(URL: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let urlSession = NSURLSession.sharedSession()
            let task = urlSession.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
                println("Response: \(response)")
                if error != nil { println(error.localizedDescription)
                }
                dispatch_async(dispatch_get_main_queue(), {
                self.dirtyMessage = self.parser.parseData(data)
                    if self.cleanItUpSwitch.on {
                        self.newMessage = self.cleanMessage.cleanUpMessage(self.dirtyMessage)
                        println(self.dirtyMessage)
                        println(self.newMessage)
                        self.foTextLabel.text = self.newMessage
                    }else {
                        self.foTextLabel.text = self.dirtyMessage
                    }
                })
            })
            task.resume()
    }
    
    //MARK: - share function

    @IBAction func shareFOButtonPressed(sender: AnyObject) {
        
        var shareText = self.foTextLabel.text as String!
        let itemsToShare = [shareText]
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        let popoverVC = activityViewController as UIViewController
        popoverVC.modalPresentationStyle = .Popover
        let popoverController = popoverVC.popoverPresentationController
        popoverController?.sourceView = toolBar as UIView
        popoverController?.sourceRect = toolBar.bounds
        popoverController?.permittedArrowDirections = .Any
        presentViewController(popoverVC, animated: true, completion: nil)
    }
    
    func shareTextImageAndURL(#sharingText: String?, sharingImage: UIImage?, sharingURL: NSURL?) {
        var sharingItems = [AnyObject]()
        
        if let text = sharingText {
            sharingItems.append(text)
        }
        if let image = sharingImage {
            sharingItems.append(image)
        }
        if let url = sharingURL {
            sharingItems.append(url)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Keyboard control
    func keyboardWillShow(notification: NSNotification)
    {
        self.keyboardIsShowing = true
        
        if let info = notification.userInfo {
            self.keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            self.arrangeViewOffsetFromKeyboard()
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        self.keyboardIsShowing = false
        self.returnViewToInitialFrame()
        
    }
    
    func arrangeViewOffsetFromKeyboard()
    {
        var theApp: UIApplication = UIApplication.sharedApplication()
        var windowView: UIView? = theApp.delegate!.window!
        
        var textFieldLowerPoint: CGPoint = CGPointMake(self.fromTextBox!.frame.origin.x, self.fromTextBox!.frame.origin.y + self.fromTextBox!.frame.size.height)
        
        var convertedTextFieldLowerPoint: CGPoint = self.view.convertPoint(textFieldLowerPoint, toView: windowView)
        
        var targetTextFieldLowerPoint: CGPoint = CGPointMake(self.fromTextBox!.frame.origin.x, self.keyboardFrame.origin.y - kPreferredTextFieldToKeyboardOffset)
        
        var targetPointOffset: CGFloat = targetTextFieldLowerPoint.y - convertedTextFieldLowerPoint.y
        var adjustedViewFrameCenter: CGPoint = CGPointMake(self.view.center.x, self.view.center.y + targetPointOffset)
        if self.keyboardFrame.origin.y < self.fromTextBox!.frame.origin.y {
            
            UIView.animateWithDuration(0.2, animations: {
                self.view.center = adjustedViewFrameCenter
            })
            
        }
    }
    
    func returnViewToInitialFrame()
    {
        var initialViewRect: CGRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)
        
        if (!CGRectEqualToRect(initialViewRect, self.view.frame))
        {
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame = initialViewRect
            });
        }
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches as Set<NSObject>, withEvent: event)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeTextView = textField
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        
        textField.resignFirstResponder()
        return true
    }


}

