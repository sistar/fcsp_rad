//
//  APIKeyAuthProvider.swift
//  Runner
//
//  Created by Ralf Sigmund on 09.12.18.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

import Foundation
import AWSAppSync
import AWSCore

class APIKeyAuthProvider : AWSAPIKeyAuthProvider {
    private var key: String
    
    init(apiKey:String) {
        self.key = apiKey
    }
    
    func getAPIKey() -> String {
        return self.key
    }
    
}
