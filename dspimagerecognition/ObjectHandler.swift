//
//  ObjectHandler.swift
//  EcoRobot
//
//  Created by Matei Crăiniceanu on 10.05.2023.
//

import Foundation

struct ObjectHandler {
    
    var serverUrl: String
    
    func handle(_ obj: RecogResponse){
        
        let json: [String:Any] = [
            "fname": obj.fname,
            "recognised": obj.recognised,
            "recognitionName": obj.recognition.name,
            "recognitionConf": obj.recognition.confidence,
            "recognitionConfPrecent": obj.recognition.confidencePrecent,
            "box":
                ["boxWidth": obj.recognition.box.width,
             "boxHeight": obj.recognition.box.height,
             "boxX": obj.recognition.box.minX,
             "boxY": obj.recognition.box.minY,
             "boxMidX": obj.recognition.box.midX,
             "boxMidY": obj.recognition.box.midY],
            "error": obj.error
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "\(serverUrl)/infoforfile")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //            print(response ?? "NoResponse")
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        
        task.resume()
    }
}
