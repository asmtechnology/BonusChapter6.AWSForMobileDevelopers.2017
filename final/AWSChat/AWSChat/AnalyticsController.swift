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
    
    //TO DO: Insert settings for the dedicated identity pool used by Mobile Analytics here.
    private let identityPoolRegion: AWSRegionType = .USEast1
    private let identityPoolD = "insert your mobile analytics identity pool id"
    
    //TO DO: Insert your Mobile Analytics application details here.
    private let appID = "insert your mobile analytics app id"
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
