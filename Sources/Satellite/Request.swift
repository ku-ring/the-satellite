//
//  Request.swift
//  
//
//  Created by Jaesung Lee on 2023/04/14.
//

import Foundation

public protocol Request {
    var key: String { get }
    func urlRequest(_ url: String) -> URLRequest?
}

public protocol Respondable {
    associatedtype ResponseType: Response
}

public protocol RequestableOnly { }

