//
//  ViewController.swift
//  HTAutocompleteTextFieldSwift
//
//  Created by crhuber on 1/26/15.
//  Copyright (c) 2015 crhuber. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myAuto1: HTAutocompleteTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myAuto1.setDefaultAutocompleteDataSource(HTAutocompleteManager.sharedManager)
        myAuto1.autocompleteType = HTAutocompleteType.HTAutocompleteTypeEmail
        
        
        
        var myEmailAutoCompleteTextFiedl: HTEmailAutocompleteTextField = HTEmailAutocompleteTextField(frame:CGRectMake(0, 10, 150, 45))
        myEmailAutoCompleteTextFiedl.center = CGPoint(x: self.view.frame.width/2, y: 150)
        myEmailAutoCompleteTextFiedl.layer.borderColor = UIColor.blackColor().CGColor
        myEmailAutoCompleteTextFiedl.layer.borderWidth = 0.5
        myEmailAutoCompleteTextFiedl.layer.cornerRadius = 5
        myEmailAutoCompleteTextFiedl.keyboardType = UIKeyboardType.EmailAddress
        self.view.addSubview(myEmailAutoCompleteTextFiedl)
        
        var myLabel2 :UILabel = UILabel(frame: CGRectMake(0, 0, 300, 45))
        myLabel2.text = "HTEmailAutocompleteTextField:"
        myLabel2.center = CGPoint(x: myEmailAutoCompleteTextFiedl.center.x, y: myEmailAutoCompleteTextFiedl.center.y - 45)
        self.view.addSubview(myLabel2)
        
        var myColorAutocompleteTextField: HTAutocompleteTextField = HTAutocompleteTextField(frame: CGRectMake(0, 0, 150, 45))
        myColorAutocompleteTextField.setDefaultAutocompleteDataSource(HTAutocompleteManager.sharedManager)
        myColorAutocompleteTextField.autocompleteType = HTAutocompleteType.HTAutocompleteTypeColor
        myColorAutocompleteTextField.center = CGPoint(x:self.view.frame.width/2, y: 250)
        myColorAutocompleteTextField.layer.borderColor = UIColor.blackColor().CGColor
        myColorAutocompleteTextField.layer.borderWidth = 0.5
        myColorAutocompleteTextField.layer.cornerRadius = 5
        self.view.addSubview(myColorAutocompleteTextField)
        
        var myLabel3 :UILabel = UILabel(frame: CGRectMake(0, 0, 300, 45))
        myLabel3.text = "HTAutocompleteTypeColor Type:"
        myLabel3.center = CGPoint(x: myColorAutocompleteTextField.center.x, y: myColorAutocompleteTextField.center.y - 45)
        self.view.addSubview(myLabel3)
        
        

        var myAutocompleteTextField: HTAutocompleteTextField = HTAutocompleteTextField(frame: CGRectMake(0, 0, 150, 45))
        myAutocompleteTextField.setDefaultAutocompleteDataSource(HTAutocompleteManager.sharedManager)
        myAutocompleteTextField.autocompleteType = HTAutocompleteType.HTAutocompleteTypeEmail
        myAutocompleteTextField.center = CGPoint(x:self.view.frame.width/2, y: 350)
        myAutocompleteTextField.layer.borderColor = UIColor.blackColor().CGColor
        myAutocompleteTextField.layer.borderWidth = 0.5
        myAutocompleteTextField.layer.cornerRadius = 5
        self.view.addSubview(myAutocompleteTextField)

        var myLabel1 :UILabel = UILabel(frame: CGRectMake(0, 0, 300, 45))
        myLabel1.text = "HTAutocompleteTypeEmail Type:"
        myLabel1.center = CGPoint(x: view.center.x, y: view.center.y - 45)
        self.view.addSubview(myLabel1)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

