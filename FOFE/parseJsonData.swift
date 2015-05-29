//
//  parseJsonData.swift
//  FOFE
//
//  Created by Jeremy Frick on 5/27/15.
//  Copyright (c) 2015 Red Anchor Software. All rights reserved.
//

import Foundation

class parseJsonData: NSObject {
    let message = FOMessage()
    
    func parseData(data: NSData) -> String {
        var error: NSError?
        
        let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSDictionary
        
        if error != nil {
            println(error?.localizedDescription)
        }
        
        message.message = jsonResult?["message"] as! String
        message.subtitle = jsonResult?["subtitle"] as! String
        
        var fullMessage = "\(self.message.message) \(self.message.subtitle)"
        return fullMessage
    }
}
