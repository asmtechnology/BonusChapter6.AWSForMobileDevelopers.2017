//
//  SNSController.swift
//  AWSChat
//
//  Created by Abhishek Mishra on 28/04/2017.
//  Copyright © 2017 ASM Technology Ltd. All rights reserved.
//

import Foundation
import AWSSNS

class SNSController {
    
    private let platformApplicationARN = "arn:aws:sns:us-east-1:700128248927:app/APNS_SANDBOX/AWSChat_iOS"
    var apnsDeviceToken:String?
    
    static let sharedInstance: SNSController = SNSController()
    private init() { }
    
    
    func registerToken(completion:@escaping (Error?)->Void) {

        if apnsDeviceToken == nil {
            completion(nil)
            return
        }
        
        let platformEndpointInput = AWSSNSCreatePlatformEndpointInput()
        platformEndpointInput?.platformApplicationArn = platformApplicationARN
        platformEndpointInput?.token = apnsDeviceToken
        
        let sns = AWSSNS.default()
        let task = sns.createPlatformEndpoint(platformEndpointInput!)
        task.continueWith { (task: AWSTask<AWSSNSCreateEndpointResponse>) -> Any? in
            completion(task.error)
            return nil
        }
    }
    
}
