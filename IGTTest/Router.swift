//
//  Router.swift
//  IGTTest
//
//  Created by EDGARDO AGNO on 22/06/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation

/**
 Types adopting the `URLRequestConvertible` protocol can be used to construct URL requests.
 Adopted from Alamofire. Since we can't use libraries, I'm copying this protocol from Alamofire.
 */
public protocol URLRequestConvertible {
    /// The URL request.
    var URLRequest: NSMutableURLRequest { get }
}

enum Router: URLRequestConvertible {
    static let baseURLString = "https://dl.dropboxusercontent.com/u/49130683/nativeapp-test.json"

    case Search()

    // MARK: URLRequestConvertible protocol
    
    var URLRequest: NSMutableURLRequest {
        let result: (path: String, parameters: [String: AnyObject]) = {
            switch self {
            case .Search() :
                return ("", ["" : ""])
            }
        }()
        
        let URL = NSURL(string: Router.baseURLString)!
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
        
        return URLRequest
    }
}