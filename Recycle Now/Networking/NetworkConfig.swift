//
//  NetworkConfig.swift
//  Recycle Now
//
//  Created by Carl on 02/03/2018.
//  Copyright © 2018 CarlJNash. All rights reserved.
//

import Foundation


// ===============================================
// MARK: - Protocol
// ===============================================

protocol TaskConfig {
    
    var identifier: String { get set }
    var request: URLRequest? { get set }
}


// ===============================================
// MARK: - URLSessionDataTaskConfig
// ===============================================

struct URLSessionDataTaskConfig {
    
    struct RecycleLocation: TaskConfig {
        
        // Protocol
        var identifier: String = "RecycleLocations"
        var request: URLRequest?
        
        // Non-protocol
        var location: String
        
        init(location: String) {
            self.location = location
            if let url = URL.init(string: "https://rl.recyclenow.com/widget/www.recyclenow.com/locations/\(self.location)?limit=30&radius=25") {
                self.request = URLRequest.init(url: url)
            }
        }
    }
}


struct URLSessionDataTaskResponse {
    
    var response: URLResponse?
    var originalRequest: URLRequest?
    var error: Error?
    var data: Data?
    var decodableResponse: Decodable?

    init(response: URLResponse?, originalRequest: URLRequest?, error: Error?, data: Data?, decodableResponse: Decodable? = nil) {
        self.response = response
        self.originalRequest = originalRequest
        self.error = error
        self.data = data
        self.decodableResponse = decodableResponse
    }
}
