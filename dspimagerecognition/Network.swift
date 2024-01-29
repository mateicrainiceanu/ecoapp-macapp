//
//  Network.swift
//  dspimagerecognition
//
//  Created by Matei Crăiniceanu on 16.01.2024.
//

import Foundation

struct JsonFilesArray: Codable {
    var fileArray: Array<String>
    var toAnalise: Bool
}

struct JsonResponseForGetFile: Codable {
    var fname: String?
    var toAnalise: Bool
}
