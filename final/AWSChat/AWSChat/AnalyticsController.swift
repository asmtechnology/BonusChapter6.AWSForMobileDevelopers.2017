//
//  AnalyticsController.swift
//  AWSChat
//
//  Created by Abhishek Mishra on 28/04/2017.
//  Copyright © 2017 ASM Technology Ltd. All rights reserved.
//

import Foundation
import AWSCore
import AWSMobileAnalytics

class AnalyticsController {
    
    private let identityPoolRegion: AWSRegionType = .USEast1

    private let identityPoolD = "us-east-1:74034201-e8f6-454e-a7e0-52b428bff06b"
    private let appID = "994e34638d084c04860b5976da50b5c4"
    private var analytics: AWSMobileAnalytics?
    
    static let sharedInstance: AnalyticsController = AnalyticsController()
    private init() {
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:identityPoolRegion,
                                                                identityPoolId: identityPoolD)
        
        
        let serviceConfiguration = AWSServiceConfiguration(region: identityPoolRegion,
                                                credentialsProvider:credentialsProvider)

        let analyticsConfiguration = AWSMobileAnalyticsConfiguration()
        analyticsConfiguration.serviceConfiguration = serviceConfiguration!
        
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
