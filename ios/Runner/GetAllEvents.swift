//
//  GetAllEvents.swift
//  Runner
//
//  Created by Ralf Sigmund on 09.12.18.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

import Foundation
import AWSCore
import AWSAppSync

class GetAllEvents {
    
    private let client: AWSAppSyncClient
    
    init(client: AWSAppSyncClient) {
        self.client = client
    }
    
    public func exec(flutterMethodCall: FlutterMethodCall, flutterResult: @escaping FlutterResult) {
        let query = GetEventsQuery()
        self.client.fetch(query: query, cachePolicy: .fetchIgnoringCacheData){ (result,error) in
            if let error = error as? AWSAppSyncClientError{
                flutterResult(FlutterError(code: "1", message: error.localizedDescription, details: nil))
            } else {
                if let errors = result!.errors {
                    let error = errors.map({ (error) -> String in
                        error.message
                    }).joined(separator: ", ")
                    flutterResult(FlutterError(code: "1", message: error, details: nil))
                } else {
                    let events = result!.data!.getEvents!
                    let values = events.map({(event)-> Dictionary<String,Any> in
                        if let it = event {
                            return ["id" : it.id,
                                    "name" : it.name,
                                    "where" : it.where,
                                    "startingTime" : it.startingTime,
                                    "description" : it.description,
                                    "discipline" : it.discipline,
                                    "distance" : it.distance,
                                    "intensity" : it.intensity,
                                    "lat" : it.lat,
                                    "lon" : it.lon,
                                "komoot" : it.komoot,
                                "plannedAvg" : it.plannedAvg
                            ]
                        } else {
                            return [:]
                        }
                    })
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: values, options: .prettyPrinted)
                        let convertedString = String(data: jsonData, encoding: String.Encoding.utf8)
                        flutterResult(convertedString)
                    } catch {
                        flutterResult(FlutterError(code: "1", message: error.localizedDescription, details: nil))
                    }
                }
            }
        }
    }
}
