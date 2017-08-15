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
    
    //TO DO: Insert your SNS platform application ARN here
    private let platformApplicationARN = "your platform application ARN"
    
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
