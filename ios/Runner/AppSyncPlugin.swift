//
//  AppSyncPlugin.swift
//  Runner
//
//  Created by Ralf Sigmund on 09.12.18.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter
import AWSCore
import AWSAppSync


public class AppSyncPlugin: NSObject, FlutterPlugin {
    static let CHANNEL_NAME = "de.sistar.fcsp_rad"
    static let QUERY_GET_ALL_EVENTS = "getEvents"
    static let MUTATION_NEW_EVENT = "createEvent"
    static let SUBSCRIBE_NEW_EVENT = "subscribeNewEvent"
    static let SUBSCRIBE_NEW_EVENT_RESULT = "subscribeNewEventResult"
    
    var appSyncClient: AWSAppSyncClient?
    
    let channel: FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = AppSyncPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        prepareClient(call: call)
        onPerformMethodCall(call: call, result: result)
    }
    
    /**
     * Handle type method. Call task for run GraphQL request
     */
    private func onPerformMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case AppSyncPlugin.QUERY_GET_ALL_EVENTS:
            GetAllEvents(client: appSyncClient!).exec(flutterMethodCall: call, flutterResult: result)
        case AppSyncPlugin.MUTATION_NEW_EVENT:
            NewEvent(client: appSyncClient!).exec(flutterMethodCall: call, flutterResult: result)
        case AppSyncPlugin.SUBSCRIBE_NEW_EVENT:
            SubscriptionToNewEvent(client: appSyncClient!, channel: self.channel).exec(flutterMethodCall: call, flutterResult: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    /**
     * Create AWS AppSync Client if not exist
     */
    private func prepareClient(call: FlutterMethodCall) {
        let args = call.arguments as! Dictionary<String, Any>
        let endpoint = args["endpoint"] as! String
        let apiKey = args["apiKey"] as! String
        let databaseName = "appsync-local-db"
        
        let databaseURL = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent(databaseName)
        
        
        do {
            let provider: AWSAPIKeyAuthProvider = APIKeyAuthProvider(apiKey: apiKey)
            let appSyncConfig = try AWSAppSyncClientConfiguration(url: URL(string:endpoint)!,
                                                                  serviceRegion: .EUCentral1,
                                                                  apiKeyAuthProvider: provider,
                                                                  databaseURL:databaseURL)
            appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
            appSyncClient?.apolloClient?.cacheKeyForObject = { $0["id"] }
            
        } catch {
            print("Error initializing AppSync client. \(error)")
        }
    }
}
