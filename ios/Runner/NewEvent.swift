//
//  NewEvent.swift
//  Runner
//
//  Created by Ralf Sigmund on 09.12.18.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

import Foundation
import AWSCore
import AWSAppSync

class NewEvent {
    private let client: AWSAppSyncClient
    
    init(client: AWSAppSyncClient) {
        self.client = client
    }
    
    public func exec(flutterMethodCall: FlutterMethodCall, flutterResult: @escaping FlutterResult) {
        let args = flutterMethodCall.arguments as! Dictionary<String,Any?>
        let content = args["content"] as! Dictionary<String,Any?>
        
        let mutation = CreateEventMutation(
            name: content["name"] as! String,
            startingTime: content["startingTime"] as! String,
            where: content["where"] as! String,
            lat: content["lat"] as! Double,
            lon: content["lon"] as! Double,
            description: content["description"] as! String,
            discipline: content["discipline"] as? String,
            distance: content["distance"] as? Double,
            intensity: content["intensity"] as? Double,
            plannedAvg: content["plannedAvg"] as? Double,
            komoot:content["komoot"] as? String)
        
        self.client.perform(mutation: mutation) { (result, error) in
            if let error = error as? AWSAppSyncClientError {
                flutterResult(FlutterError(code: "1", message: error.localizedDescription, details: nil))
            } else {
                if let errors = result!.errors {
                    let error = errors.map({ (error) -> String in
                        error.message
                    }).joined(separator: ", ")
                    flutterResult(FlutterError(code: "1", message: error, details: nil))
                } else {
                    let it = result!.data!.createEvent!
                    let values:[String:Any] = [
                        "id": it.id,
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

