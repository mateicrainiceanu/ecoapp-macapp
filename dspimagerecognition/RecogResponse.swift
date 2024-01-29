//
//  RecogResponse.swift
//  dspimagerecognition
//
//  Created by Matei Crăiniceanu on 16.01.2024.
//

import Foundation

struct RecogResponse: Codable {
    var serverUrl: String
    var error: String = ""
    var recognised: Bool = false
    var recognition: Recognition = Recognition(box: CGRect(), name: "", confidence: 0)
    var fname: String = ""
    
    func handleError () {
        if error != "" {
            let json: [String:Any] = [
                "fname": self.fname,
                "error": self.error
            ]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            let url = URL(string: "\(serverUrl)/error")!
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
}
