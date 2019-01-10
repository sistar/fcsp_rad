//
//  SubscriptionToNewEvent.swift
//  Runner
//
//  Created by Ralf Sigmund on 09.12.18.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

import Foundation
import AWSCore
import AWSAppSync


class SubscriptionToNewEvent {
    
    private let client: AWSAppSyncClient
    private let channel: FlutterMethodChannel
    
    init(client: AWSAppSyncClient, channel: FlutterMethodChannel) {
        self.client = client
        self.channel = channel
    }
    
    public func exec(flutterMethodCall: FlutterMethodCall, flutterResult: @escaping FlutterResult) {
        do {
            let subscription = SubscribeNewEventSubscription()
            try self.client.subscribe(subscription: subscription, resultHandler: ({ (result, transaction, error) in
                if let result = result {
                    if let it = result.data?.subscribeNewEvent {
                        let values:[String:Any] = [
                            "id" : it.id,
                            "name" : it.name as Any,
                            "where" : it.where as Any,
                            "startingTime" : it.startingTime as Any,
                            "description" : it.description as Any,
                            "discipline" : it.discipline as Any,
                            "distance" : it.distance as Any ,
                            "intensity" : it.intensity  as Any ,
                            "lat" : it.lat as Any ,
                            "lon" : it.lon as Any,
                            "komoot" : it.komoot as Any,
                            "plannedAvg" : it.plannedAvg as Any
                        ]
                        
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: values, options: .prettyPrinted)
                            let convertedString = String(data: jsonData, encoding: String.Encoding.utf8)
                            self.channel.invokeMethod(AppSyncPlugin.SUBSCRIBE_NEW_EVENT_RESULT, arguments: convertedString)
                        } catch {
                            flutterResult(FlutterError(code: "1", message: error.localizedDescription, details: nil))
                        }
                    }
                    
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }))
        } catch {
            print("Error starting subscription.")
        }
    }
}
