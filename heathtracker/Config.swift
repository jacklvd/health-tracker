//
//  Config.swift
//  heathtracker
//
//  Created by Jack Vo on 8/7/25.
//

import Foundation

struct Config {
    static let apiKey: String = {
        // Try to load from plist file first
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
            if let plist = NSDictionary(contentsOfFile: path),
               let key = plist["API_KEY"] as? String, !key.isEmpty {
                return key
            }
        }
        
        // Fallback to environment variable (for development)
        if let envKey = ProcessInfo.processInfo.environment["API_NINJAS_KEY"], !envKey.isEmpty {
            return envKey
        }
        
        // Last resort - return empty string
        return ""
    }()
}
