//
//  HTAutocompleteManager.swift
//  HTAutocompleteTextFieldSwift
//
//  Created by crhuber on 1/26/15.
//  Copyright (c) 2015 crhuber. All rights reserved.
//

import UIKit

// MARK: - Enum - HTAutocompleteType
enum HTAutocompleteType : Int {
    case HTAutocompleteTypeEmail = 1, HTAutocompleteTypeColor
}

class HTAutocompleteManager: NSObject, HTAutocompleteDataSource {
    
    class var sharedManager : HTAutocompleteManager {
        struct Static {
            static let instance : HTAutocompleteManager = HTAutocompleteManager()
        }
        return Static.instance
    }
    
    override init(){
        super.init()
    }
    // MARK: - HTAutocompleteTextFieldDelegate
    func textField(textField:HTAutocompleteTextField, completionForPrefix prefix:NSString, ignoreCase:Bool ) -> String {
        if (textField.autocompleteType == HTAutocompleteType.HTAutocompleteTypeEmail)
        {
            var autocompleteArray : Array = [  "gmail.com",
                "yahoo.com",
                "hotmail.com",
                "aol.com",
                "comcast.net",
                "me.com",
                "msn.com",
                "live.com",
                "sbcglobal.net",
                "ymail.com",
                "att.net",
                "mac.com",
                "cox.net",
                "verizon.net",
                "hotmail.co.uk",
                "bellsouth.net",
                "rocketmail.com",
                "aim.com",
                "yahoo.co.uk",
                "earthlink.net",
                "charter.net",
                "optonline.net",
                "shaw.ca",
                "yahoo.ca",
                "googlemail.com",
                "mail.com",
                "qq.com",
                "btinternet.com",
                "mail.ru",
                "live.co.uk",
                "naver.com",
                "rogers.com",
                "juno.com",
                "yahoo.com.tw",
                "live.ca",
                "walla.com",
                "163.com",
                "roadrunner.com",
                "telus.net",
                "embarqmail.com",
                "hotmail.fr",
                "pacbell.net",
                "sky.com",
                "sympatico.ca",
                "cfl.rr.com",
                "tampabay.rr.com",
                "q.com",
                "yahoo.co.in",
                "yahoo.fr",
                "hotmail.ca",
                "windstream.net",
                "hotmail.it",
                "web.de",
                "asu.edu",
                "gmx.de",
                "gmx.com",
                "insightbb.com",
                "netscape.net",
                "icloud.com",
                "frontier.com",
                "126.com",
                "hanmail.net",
                "suddenlink.net",
                "netzero.net",
                "mindspring.com",
                "ail.com",
                "windowslive.com",
                "netzero.com",
                "yahoo.com.hk",
                "yandex.ru",
                "mchsi.com",
                "cableone.net",
                "yahoo.com.cn",
                "yahoo.es",
                "yahoo.com.br",
                "cornell.edu",
                "ucla.edu",
                "us.army.mil",
                "excite.com",
                "ntlworld.com",
                "usc.edu",
                "nate.com",
                "outlook.com",
                "nc.rr.com",
                "prodigy.net",
                "wi.rr.com",
                "videotron.ca",
                "yahoo.it",
                "yahoo.com.au",
                "umich.edu",
                "ameritech.net",
                "libero.it",
                "yahoo.de",
                "rochester.rr.com",
                "cs.com",
                "frontiernet.net",
                "swbell.net",
                "msu.edu",
                "ptd.net",
                "proxymail.facebook.com",
                "hotmail.es",
                "austin.rr.com",
                "nyu.edu",
                "sina.com",
                "centurytel.net",
                "usa.net",
                "nycap.rr.com",
                "uci.edu",
                "hotmail.de",
                "yahoo.com.sg",
                "email.arizona.edu",
                "yahoo.com.mx",
                "ufl.edu",
                "bigpond.com",
                "unlv.nevada.edu",
                "yahoo.cn",
                "ca.rr.com",
                "google.com",
                "yahoo.co.id",
                "inbox.com",
                "fuse.net",
                "hawaii.rr.com",
                "talktalk.net",
                "gmx.net",
                "walla.co.il",
                "ucdavis.edu",
                "carolina.rr.com",
                "comcast.com",
                "live.fr",
                "blueyonder.co.uk",
                "live.cn",
                "cogeco.ca",
                "abv.bg",
                "tds.net",
                "centurylink.net",
                "yahoo.com.vn",
                "uol.com.br",
                "osu.edu",
                "san.rr.com",
                "rcn.com",
                "umn.edu",
                "live.nl",
                "live.com.au",
                "tx.rr.com",
                "eircom.net",
                "sasktel.net",
                "post.harvard.edu",
                "snet.net",
                "wowway.com",
                "live.it",
                "hoteltonight.com",
                "att.com",
                "vt.edu",
                "rambler.ru",
                "temple.edu",
                "cinci.rr.com"]
            // Check that text field contains an @
            var atSignRange = prefix.rangeOfString("@")
            if (atSignRange.location == NSNotFound) {
                return ""
            }
            
            // Stop autocomplete if user types dot after domain
            var domainAndTLD: NSString = prefix.substringFromIndex(atSignRange.location)
            var rangeOfDot = domainAndTLD.rangeOfString(".")
            if (rangeOfDot.location != NSNotFound) {
                return ""
            }
            
            // Check that there aren't two @-signs
            var textComponents = prefix.componentsSeparatedByString("@") as [String]
            if (textComponents.count > 2) {
                return ""
            }
            
            if (textComponents.count > 1) {
                let str : String = textComponents[1]
                // If no domain is entered, use the first domain in the list
                if (str.characters.count == 0) {
                    return autocompleteArray[0]
                }
                var textAfterAtSign = textComponents[1]
                var stringToLookFor: String?
                
                if (ignoreCase) {
                    stringToLookFor = textAfterAtSign.lowercaseString
                }
                else {
                    stringToLookFor = textAfterAtSign as String
                    
                }
                for (index, stringFromReference) in autocompleteArray.enumerate() {
                    var stringToCompare:NSString
                    if (ignoreCase) {
                        stringToCompare = stringFromReference.lowercaseString
                    }
                    else {
                        stringToCompare = stringFromReference
                    }
                    if (stringToCompare.hasPrefix(stringToLookFor!))
                    {
                        let index = stringFromReference.startIndex.advancedBy((stringToLookFor!.characters.count))
                        return stringFromReference.substringFromIndex(index)
                    }
                    
                }
                
            }
            
        } else if (textField.autocompleteType == HTAutocompleteType.HTAutocompleteTypeColor) {
            var colorAutocompleteArray : Array = ["Alfred",
                "Beth",
                "Carlos",
                "Daniel",
                "Ethan",
                "Fred",
                "George",
                "Helen",
                "Inis",
                "Jennifer",
                "Kylie",
                "Liam",
                "Melissa",
                "Noah",
                "Omar",
                "Penelope",
                "Quan",
                "Rachel",
                "Seth",
                "Timothy",
                "Ulga",
                "Vanessa",
                "William",
                "Xao",
                "Yilton",
                "Zander"]
            
            var stringToLookFor :String
            var componentsString :[String] = prefix.componentsSeparatedByString(",") as [String]
            
            var prefixLastComponent: String = (componentsString.last as String!).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if (ignoreCase)
            {
                stringToLookFor = prefixLastComponent.lowercaseString
            }
            else
            {
                stringToLookFor = prefixLastComponent
            }
            for (index, stringFromReference) in colorAutocompleteArray.enumerate()
            {
                var stringToCompare:String
                if (ignoreCase)
                {
                    stringToCompare = stringFromReference.lowercaseString
                }
                else
                {
                    stringToCompare = stringFromReference
                }
                
                if (stringToCompare.hasPrefix(stringToLookFor)) {
                    let index = stringFromReference.startIndex.advancedBy((stringToLookFor.characters.count))
                    return stringFromReference.substringFromIndex(index)
                }
                
            }
            
        }
        return "";
    }
}
