//
//  Recognition.swift
//  EcoRobot
//
//  Created by Matei Crăiniceanu on 06.05.2023.
//

import Foundation

struct Recognition: Codable {
    let box: CGRect
    let name: String
    var confidence: Float
    var confidencePrecent: String {
        get {
            return "\(confidence * 100)%"
        }
    }
    
    func getValues() {
        print("\(Date()) | REC: \(name) | conf: \(confidencePrecent)")
    }
}
