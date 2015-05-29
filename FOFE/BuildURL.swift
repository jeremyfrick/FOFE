//
//  BuildURL.swift
//  FOFE
//
//  Created by Jeremy Frick on 5/27/15.
//  Copyright (c) 2015 Red Anchor Software. All rights reserved.
//

import Foundation

class BuildURL: NSObject {
    var url = NSURL()
    let baseUrl = NSURL(string: "http://foaas.com/")
    
    func buildUrl(to: String, from: String, yell: Bool) -> NSURL {
        
        var randomFO = randomFoMessage(to, from: from)
        
        if yell {
            url =  NSURL(string: randomFO + "?shoutcloud", relativeToURL: baseUrl)!
            return url
        } else {
            url =  NSURL(string: randomFO, relativeToURL: baseUrl)!
            return url
        }
}

    func randomFoMessage(to: String, from: String) -> String {
        var messageArray = ["/awesome/\(from)", "/because/\(from)", "/bucket/\(from)", "/bus/\(to)/\(from)","/bye/\(from)","/yoda/\(to)/\(from)","/nugget/\(to)/\(from)"]
        var randomIndex = Int(arc4random_uniform(UInt32(messageArray.count)))
        var message = messageArray[randomIndex]
        return message
    }
}
