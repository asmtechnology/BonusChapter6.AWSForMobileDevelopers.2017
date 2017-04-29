//
//  AnalyticsController.swift
//  AWSChat
//
//  Created by Abhishek Mishra on 28/04/2017.
//  Copyright © 2017 ASM Technology Ltd. All rights reserved.
//

import Foundation
import AWSMobileAnalytics

class AnalyticsController {
    
    private let appID = "arn:aws:sns:us-east-1:700128248927:app/APNS_SANDBOX/AWSChat_iOS"
    private var analytics: AWSMobileAnalytics?
    
    static let sharedInstance: AnalyticsController = AnalyticsController()
    private init() {
        let analyticsConfiguration = AWSMobileAnalyticsConfiguration()
        analytics = AWSMobileAnalytics(forAppId: appID, configuration: analyticsConfiguration)
    }
    
    
    func postCustomEvent(eventType:String, eventAttributes:[String: String]?) {
        
        guard let analytics = self.analytics,
            let eventClient = analytics.eventClient else {
            return
        }
        
        let event = eventClient.createEvent(withEventType: eventType)
        
        if let eventAttributes = eventAttributes {
            for key in eventAttributes.keys {
                let value = eventAttributes[key]
                event?.addAttribute(value, forKey: key)
            }
        }
        
        eventClient.record(event)
        eventClient.submitEvents()
    }
    
}
