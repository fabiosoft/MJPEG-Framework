//
//  URLConnectionDataDelegate.swift
//  ip-camera-viewer
//
//  Created by Ugo Arangino on 19.12.14.
//  Copyright (c) 2014 Ugo Arangino. All rights reserved.
//

import Foundation

/**
*  A NSURLConnectionDataDelegate implementation
*/
public class URLConnectionDataDelegate: NSObject, NSURLConnectionDataDelegate {
    
    weak var connection: URLConnection?
    
    private var connectionData: ConnectionData
    private var data = Data()
    
    
    public init(connectionData: ConnectionData) {
        self.connectionData = connectionData
    }
    
    
    // MARK: - NSURLConnectionDelegate
    // ServerTrust and HTTPBasic
    
    public func connection(_ connection: NSURLConnection, willSendRequestFor challenge: URLAuthenticationChallenge) {
        
        // NSURLAuthenticationMethod - ServerTrust
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            challenge.sender?.use(credential , for: challenge)
        }
        
        // NSURLAuthenticationMethod - HTTPBasic
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic {
            if self.connectionData.user != nil && self.connectionData.password != nil {
                let credential = URLCredential(user: connectionData.user!, password: connectionData.password!, persistence: URLCredential.Persistence.synchronizable)
                challenge.sender?.use(credential, for: challenge)
            }
        }
    }
    
    
    // MARK: - NSURLConnectionDataDelegate
    
    public func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        // put through data
        self.connection?.delegate?.responseDidFinish(data: self.data)
        
        // reset data
        self.data.count = 0
    }
    
    public func connection(_ connection: NSURLConnection, didReceive data: Data) {
        self.data.append(data)
    }
    
}
