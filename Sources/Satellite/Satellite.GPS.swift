//
//  Satellite.GPS.swift
//  
//
//  Created by Jaesung Lee on 2023/06/04.
//

import Foundation

extension Satellite {
    /// Start Global Printing System
    public func _startGPS() {
        self._isGPSEnabled = true
    }
    
    /// Start Global Printing System
    public func _endGPT() {
        self._isGPSEnabled = false
    }
    
    public func showGPT(_ stringValue: String, function: StaticString = #function, file: StaticString = #fileID, line: UInt = #line) {
        guard _isGPSEnabled else { return }
        let log = ("\n🛰️ Satellite: \(host)\t\(Date())\n📄file: \(file)\tline: \(line)\tfunction: \(function)\n📡 \(stringValue)\n")
        print(log)
        _gpsLogs.append(log)
    }
}
