//
//  HTAutocompleteTextField.swift
//  HTAutocompleteTextFieldSwift
//
//  Created by crhuber on 1/26/15.
//  Copyright (c) 2015 crhuber. All rights reserved.
//

import UIKit

let kHTAutoCompleteButtonWidth:CGFloat = 30
var DefaultAutocompleteDataSource: HTAutocompleteDataSource?

// MARK: - HTAutocompleteDataSource
@objc protocol HTAutocompleteDataSource: NSObjectProtocol {
    func textField(textField: HTAutocompleteTextField,completionForPrefix prefix:NSString, ignoreCase: Bool) -> String
}

// MARK: - HTAutocompleteTextFieldDelegate
@objc protocol HTAutocompleteTextFieldDelegate: NSObjectProtocol {
    optional func autoCompleteTextFieldDidAutoComplete(autoCompleteField:HTAutocompleteTextField) -> Void
    optional func autocompleteTextField(autocompleteTextField:HTAutocompleteTextField,didChangeAutocompleteText autocompleteText:NSString) -> Void
}

class HTAutocompleteTextField: UITextField{
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    /*
    * Autocomplete behavior
    */
    var autocompleteType:HTAutocompleteType? // Can be used by the dataSource to provide different types of autocomplete behavior
    var autocompleteDisabled:Bool = false
    var ignoreCase:Bool = false
    var needsClearButtonSpace:Bool = false
    var showAutocompleteButton:Bool = false
    var autoCompleteTextFieldDelegate: HTAutocompleteTextFieldDelegate!
    var correctionNew:CGFloat = 0.0
    
    var autocompleteString:String! = "" {
        didSet {
            self.updateAutocompleteButtonAnimated(true)
        }
        
    }
    var autocompleteButton: UIButton! {
        didSet {
            self.updateAutocompleteButtonAnimated(true)
        }
    }
    
    /*
    * Configure text field appearance
    */
    var autocompleteLabel:UILabel!
    var autocompleteTextOffset:CGPoint = CGPoint(x: 0, y: 0)
    
    
    /*
    * Specify a data source responsible for determining autocomplete text.
    */
    var autocompleteDataSource : HTAutocompleteDataSource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupAutocompleteTextField()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        correctionNew = 6.0
        self.setupAutocompleteTextField()
    }
    
    func setupAutocompleteTextField() -> Void {
        
        self.autocompleteLabel = UILabel(frame:CGRectZero)
        self.autocompleteLabel.font = self.font
        self.autocompleteLabel.backgroundColor = UIColor.clearColor()
        self.autocompleteLabel.textColor = UIColor.lightGrayColor()
        
        let lineBreakMode: NSLineBreakMode = NSLineBreakMode.ByClipping
        
        //        if (checkVersion("6.0.0") == 1){
        //            var lineBreakMode: NSLineBreakMode = NSLineBreakMode.ByClipping
        //        } else {
        //            var lineBreakMode: UILineBreakMode =
        //
        //        }
        self.autocompleteLabel.lineBreakMode = lineBreakMode
        self.autocompleteLabel.hidden = true
        self.addSubview(autocompleteLabel)
        self.bringSubviewToFront(autocompleteLabel)
        
        self.autocompleteButton = UIButton(type: UIButtonType.Custom)
        self.autocompleteButton.addTarget(self, action: "autocompleteText:", forControlEvents: UIControlEvents.TouchUpInside)
        self.autocompleteButton.setImage(UIImage(named: "autocompleteButton"), forState:  UIControlState.Normal)
        self.addSubview(autocompleteButton)
        self.bringSubviewToFront(autocompleteButton)
        
        self.autocompleteString = ""
        
        self.ignoreCase = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ht_textDidChange:", name: UITextFieldTextDidChangeNotification, object: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.autocompleteButton?.frame = self.frameForAutocompleteButton()
    }
    
    // MARK: - Configuration
    func setDefaultAutocompleteDataSource(dataSource:HTAutocompleteDataSource) {
        DefaultAutocompleteDataSource = dataSource;
    }
    
    func changefont(font: UIFont) {
        super.font = font
        self.autocompleteLabel.font = font
    }
    
    // MARK: - UIResponder
    
    override func becomeFirstResponder() -> Bool {
        // This is necessary because the textfield avoids tapping the autocomplete Button
        // self.bringSubviewToFront(self.autocompleteButton)
        if(!self.autocompleteDisabled) {
            if (self.clearsOnBeginEditing) {
                self.autocompleteLabel.text = ""
            }
            
            self.autocompleteLabel.hidden = false
        }
        
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        if(!self.autocompleteDisabled) {
            self.autocompleteLabel.hidden = true
            
            if(self.commitAutocompleteText()) {
                // Only notify if committing autocomplete actually changed the text.
                // This is necessary because committing the autocomplete text changes the text field's text, but for some reason UITextField doesn't post the UITextFieldTextDidChangeNotification notification on its own
                NSNotificationCenter.defaultCenter().postNotificationName(UITextFieldTextDidChangeNotification,object:self)
            }
        }
        return super.resignFirstResponder()
    }
    
    // MARK: - Autocomplete Logic
    func autocompleteRectForBounds(bounds: CGRect) -> CGRect {
        var returnRect: CGRect = CGRectZero
        // get bounds for whole text area
        var textRectBounds: CGRect = self.textRectForBounds(self.bounds)
        
        // get rect for actual text
        var textRange: UITextRange = self.textRangeFromPosition(self.beginningOfDocument, toPosition: self.endOfDocument)!
        var textRect: CGRect = CGRectIntegral(self.firstRectForRange(textRange))
        
        var lineBreakMode: NSLineBreakMode = NSLineBreakMode.ByClipping
        //        if (checkVersion(60000) == 1){
        //            var lineBreakMode: NSLineBreakMode = NSLineBreakByCharWrapping
        //        } else {
        //            var lineBreakMode: UILineBreakMode = UILineBreakModeCharacterWrap
        //        }
        var autocompleteTextSize: CGSize!
        if (checkVersion("7.0.0") == 1) {
            var paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode =  lineBreakMode
            
            var attributes:Dictionary = [NSFontAttributeName: self.font!, NSParagraphStyleAttributeName:paragraphStyle]
            var _text: NSString = self.text! as NSString
            
            var prefixTextRect: CGRect = _text.boundingRectWithSize(textRectBounds.size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
            var prefixTextSize: CGSize = prefixTextRect.size
            
            var _autocompleteString = self.autocompleteString as NSString
            var autocompleteTextRect: CGRect = _autocompleteString.boundingRectWithSize(textRectBounds.size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
            autocompleteTextSize = autocompleteTextRect.size
            
        } else {
            var _text: NSString = self.text! as NSString
            var paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode =  lineBreakMode
            var attributes:Dictionary = [NSFontAttributeName:self.font!, NSParagraphStyleAttributeName:paragraphStyle]
            var prefixTextSize: CGSize = _text.sizeWithAttributes(attributes)
            
            var _autocompleteString = self.autocompleteString as NSString
            autocompleteTextSize = _autocompleteString.sizeWithAttributes(attributes)
        }
        
        var correction :CGFloat = 0.0;
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            // there is a slightly different return value for firstRectForRange in iOS7
            correction = 6.0
        }
        correction = correctionNew
        
        returnRect = CGRectMake((CGRectGetMaxX(textRect) + correction + self.autocompleteTextOffset.x),
            CGRectGetMinY(textRectBounds) + self.autocompleteTextOffset.y,
            autocompleteTextSize.width,
            textRectBounds.size.height);
        return returnRect
        
    }
    
    func ht_textDidChange(notification: NSNotification){
        self.refreshAutocompleteText()
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.endEditing(true)
        return false
    }
    func updateAutocompleteLabel() {
        print("autocompleteString is: \(autocompleteString)")
        self.autocompleteLabel.text = self.autocompleteString
        self.autocompleteLabel.sizeToFit()
        self.autocompleteLabel.frame = self.autocompleteRectForBounds(self.bounds)
        self.sendActionsForControlEvents(UIControlEvents.EditingChanged)
        
        //TODO:
        //        if(self.autoCompleteTextFieldDelegate.respondsToSelector("autocompleteTextField:didChangeAutocompleteText:")) {
        //        self.autoCompleteTextFieldDelegate.autocompleteTextField!(self, didChangeAutocompleteText: autocompleteString)
        //        }
    }
    
    func refreshAutocompleteText() {
        if (!self.autocompleteDisabled) {
            var dataSource : HTAutocompleteDataSource?
            
            if((self.autocompleteDataSource?.respondsToSelector("textField:completionForPrefix:ignoreCase:")) != nil){
                dataSource = self.autocompleteDataSource!
            } else if(DefaultAutocompleteDataSource?.respondsToSelector("textField:completionForPrefix:ignoreCase:") != nil) {
                dataSource = DefaultAutocompleteDataSource!
            }
            
            autocompleteString  = dataSource?.textField(self, completionForPrefix: self.text!, ignoreCase: self.ignoreCase)
            
            if (autocompleteString.characters.count > 0) {
                var textLength = self.text!.characters.count
                if (textLength == 0 || textLength == 1) {
                    self.updateAutocompleteButtonAnimated(true)
                }
            }
            
            self.updateAutocompleteLabel()
        }
        
    }
    
    func commitAutocompleteText() -> Bool {
        var currentText:String = self.text!
        if(self.autocompleteString.characters.count > 0 && self.autocompleteDisabled == false) {
            self.text = self.text! + self.autocompleteString
            self.autocompleteString = "";
            self.updateAutocompleteLabel()
            
            //            if (self.autoCompleteTextFieldDelegate.respondsToSelector("autoCompleteTextFieldDidAutoComplete:")) {
            //                self.autoCompleteTextFieldDelegate.autoCompleteTextFieldDidAutoComplete!(self)
            //            }
        }
        
        return !(currentText == self.text)
    }
    
    func forceRefreshAutocompleteText() {
        self.refreshAutocompleteText()
    }
    
    //    // MARK: - Accessors
    //
    //    func setAutocompleteString(autocompleteString: String) {
    //        self.autocompleteString = autocompleteString
    //        self.updateAutocompleteButtonAnimated(true)
    //    }
    //
    //    func setShowAutocompleteButton(showAutocompleteButton:Bool) {
    //        self.showAutocompleteButton = showAutocompleteButton
    //        self.updateAutocompleteButtonAnimated(true)
    //    }
    
    // MARK: - Private Methods
    
    func frameForAutocompleteButton() -> CGRect {
        var autocompletionButtonRect: CGRect = CGRectZero
        if (self.clearButtonMode == UITextFieldViewMode.Never || self.text?.characters.count == 0) {
            autocompletionButtonRect = CGRectMake(self.bounds.size.width - kHTAutoCompleteButtonWidth, (self.bounds.size.height/2) - (self.bounds.size.height-8)/2, kHTAutoCompleteButtonWidth, self.bounds.size.height-8);
        }
        else {
            autocompletionButtonRect = CGRectMake(self.bounds.size.width - 25 - kHTAutoCompleteButtonWidth, (self.bounds.size.height/2) - (self.bounds.size.height-8)/2, kHTAutoCompleteButtonWidth, self.bounds.size.height-8);
        }
        
        return autocompletionButtonRect
    }
    
    // Method fired by autocompleteButton for multiRecognition
    
    func autocompleteText(sender: UIButton) {
        if (!self.autocompleteDisabled)
        {
            self.autocompleteLabel.hidden = false
            self.commitAutocompleteText()
            // This is necessary because committing the autocomplete text changes the text field's text, but for some reason UITextField doesn't post the UITextFieldTextDidChangeNotification notification on its own
            NSNotificationCenter.defaultCenter().postNotificationName(UITextFieldTextDidChangeNotification,object:self)
        }
    }
    
    func updateAutocompleteButtonAnimated(animated:Bool) {
        if (animated)
        {
            UIView.animateWithDuration(0.15, animations:{
                var autocompleteStringLength =  self.autocompleteString.characters.count
                if (autocompleteStringLength>0 && self.showAutocompleteButton)
                {
                    self.autocompleteButton.alpha = 1
                    self.autocompleteButton.frame = self.frameForAutocompleteButton()
                }
                else
                {
                    self.autocompleteButton.alpha = 0
                }
            })
        } else
        {
            UIView.animateWithDuration(0.15, animations:{
                var autocompleteStringLength = self.autocompleteString.characters.count
                if (autocompleteStringLength>0 && self.showAutocompleteButton)
                {
                    self.autocompleteButton.alpha = 1;
                    self.autocompleteButton.frame = self.frameForAutocompleteButton()
                }
                else
                {
                    self.autocompleteButton.alpha = 0;
                }
            })
        }
    }
    
    
    
    func checkVersion(ref : String) -> Int {
        let sys = UIDevice.currentDevice().systemVersion
        switch sys.compare(ref, options: NSStringCompareOptions.NumericSearch, range: nil, locale: nil) {
        case .OrderedAscending:
            return 1 // ("\(ref) is greater than \(sys)")
        case .OrderedDescending:
            return 2 // ("\(ref) is less than \(sys)")
        case .OrderedSame:
            return 0 //("\(ref) is the same as \(sys)")
        }
    }
    
}
