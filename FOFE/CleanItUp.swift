//
//  CleanItUp.swift
//  FOFE
//
//  Created by Jeremy Frick on 5/28/15.
//  Copyright (c) 2015 Red Anchor Software. All rights reserved.
//

import Foundation

class CleanItUp: NSObject {

    func cleanUpMessage(message: String) -> String {
        var oldMessage = NSMutableString(string: message)
        let fuck = NSRegularExpression(pattern: "\\bfuck\\b",options: .CaseInsensitive, error: nil)!
        fuck.replaceMatchesInString(oldMessage, options: nil, range: NSMakeRange(0, oldMessage.length), withTemplate: "frack")
        
        let fucking = NSRegularExpression(pattern: "\\bfucking\\b",options: .CaseInsensitive, error: nil)!
        fucking.replaceMatchesInString(oldMessage, options: nil, range: NSMakeRange(0, oldMessage.length), withTemplate: "fricking")
        
        let fuckity = NSRegularExpression(pattern: "\\bfuckity\\b",options: .CaseInsensitive, error: nil)!
        fuckity.replaceMatchesInString(oldMessage, options: nil, range: NSMakeRange(0, oldMessage.length), withTemplate: "bibbity")
        
        return oldMessage as String
    }
}
