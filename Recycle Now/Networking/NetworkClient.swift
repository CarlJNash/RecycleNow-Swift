//
//  NetworkClient.swift
//  Recycle Now
//
//  Created by Carl on 26/02/2018.
//  Copyright © 2018 CarlJNash. All rights reserved.
//

import Foundation

class NetworkClient: NSObject {
    
    // ===============================================
    // MARK: - Public properties
    // ===============================================
    
    static var shared = NetworkClient.init()
    
    lazy var urlSession: URLSession = {
        return URLSession.init(configuration: self.sessionConfig,
                               delegate: self.sessionDelegate,
                               delegateQueue: self.delegateQueue)
    }()
    
    
    
    // ===============================================
    // MARK: - Private properties
    // ===============================================
    
    
    private var sessionConfig: URLSessionConfiguration {
        return URLSessionConfiguration.default
    }
    
    private var sessionDelegate: URLSessionDelegate?
    
    private lazy var delegateQueue: OperationQueue = {
        let queue = OperationQueue.main
        queue.name = "NetworkClientDefaultQueue"
        return queue
    }()
    
    
    
    // ===============================================
    // MARK: - Init
    // ===============================================
    
    // Override to make it private
    private override init() {
        super.init()
    }
    
    
    
    // ===============================================
    // MARK: - Public functions
    // ===============================================
    
    @discardableResult public func dataTaskWith<DecodableType>(config: TaskConfig,
                                                               decodableType: DecodableType.Type,
                                                               successBlock: @escaping (_ sessionResponse: URLSessionDataTaskResponse) -> Void,
                                                               failureBlock: @escaping (_ sessionResponse: URLSessionDataTaskResponse) -> Void) -> URLSessionDataTask? where DecodableType : Decodable {
        guard let request = config.request else {
            return nil
        }
        
        let dataTask: URLSessionDataTask = urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
            self.handleURLSessionDataTaskResponse(config: config,
                                                  decodableType: decodableType,
                                                  data: data,
                                                  response: response,
                                                  error: error,
                                                  successBlock: successBlock,
                                                  failureBlock: failureBlock)
            
        })
        
        dataTask.resume()
        return dataTask
    }
    
    
    
    // ===============================================
    // MARK: - Private Functions
    // ===============================================
    
    private func handleURLSessionDataTaskResponse<DecodableType>(config: TaskConfig,
                                                                 decodableType: DecodableType.Type,
                                                                 data: Data?,
                                                                 response: URLResponse?,
                                                                 error: Error?,
                                                                 successBlock: @escaping (_ sessionResponse: URLSessionDataTaskResponse) -> Void,
                                                                 failureBlock: @escaping (_ sessionResponse: URLSessionDataTaskResponse) -> Void) -> Void where DecodableType : Decodable {
        var sessionResponse = URLSessionDataTaskResponse.init(response: response,
                                                              originalRequest: config.request,
                                                              error: error,
                                                              data: data)
        guard let data = data else {
            failureBlock(sessionResponse)
            return
        }
        do {
            let result = try JSONDecoder().decode(decodableType.self, from: data)
            sessionResponse.decodableResponse = result
            successBlock(sessionResponse)
        } catch {
            failureBlock(sessionResponse)
        }
    }
}
