//
//  Response.swift
//  
//
//  Created by Jaesung Lee on 2023/04/14.
//

import Foundation

public protocol Response: Decodable {
    associatedtype RequestType: Request
}
