//
//  Handler.swift
//  dspimagerecognition
//
//  Created by Matei Crăiniceanu on 16.01.2024.
//

import Foundation
import CoreGraphics
import CoreImage
import ImageIO
import Vision
import CoreML

import SwiftUI

class Handler {
    
    var serverURL: String
    var timer: Timer?
    var running: Bool = false
    var filename = "None"
    var status = "-"
    
    init(serverURL:String) {
        self.serverURL = serverURL
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(refreshAppInfo), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    @objc private func refreshAppInfo() {
        if running {
            DispatchQueue.global().async {
                // Simulate a background task
                print("Refreshing app")
                self.getImageFileName()
            }}
    }
    
    func getImageFileName(){
        
        self.status = "getting file name"
        
        guard let url = URL(string: "\(serverURL)/filestoanalise") else {
            fatalError("SERVER ADRESS WRONG")
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                
                let decoder = JSONDecoder()
                
                do {
                    let decoded = try decoder.decode(JsonResponseForGetFile.self, from: data)
                    
                    //print(decoded)
                    
                    if let fname = decoded.fname {
                        print(fname)
                        self.filename = fname
                        self.startRecognizing(fname)
                    } else {
                        self.status = "Failed TO GET FILE"
                    }
                    
                } catch {
                    print(error.localizedDescription)
                    self.status = "Failed TO GET FILE"
                }
                
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        
        task.resume()
    }
    
    func startRecognizing(_ fileName: String) {
        
        var recogResponse = RecogResponse(serverUrl: serverURL)
        
        recogResponse.fname = fileName
        
        let urlString = "\(serverURL)/file/\(fileName)"
        
        guard let url = URL(string: urlString) else {
            recogResponse.error = "Invalid URL"
            self.status = "Invalid Filename"
            recogResponse.handleError()
            return
        }
        
        guard let cgImage = cgImageFromURL(url) else {
            recogResponse.error = "Failed To get Image"
            self.status = "Failed To get Image"
            recogResponse.handleError()
            return
        }
        
        // RUN RECOGNITION
        
        guard let model = try? VNCoreMLModel(for: DozaModel(configuration: MLModelConfiguration()).model) else {
            fatalError("Could not import model")
        }
        
        let request = VNCoreMLRequest(model: model, completionHandler: {(req, err) in
            if let results = req.results as? [VNRecognizedObjectObservation]{
                if let recognizedObject = results.first {
                    recogResponse.recognised = true
                    let box = recognizedObject.boundingBox
                    
                    if let observation = recognizedObject.labels.first {
                        let rObj = Recognition(box: box, name: observation.identifier, confidence: observation.confidence)
                        rObj.getValues()
                        recogResponse.recognition = rObj
                        self.status = observation.identifier
                        ObjectHandler(serverUrl: self.serverURL).handle(recogResponse)
                    }
                    
                } else {
                    recogResponse.error = "Could not identfy any object in your image"
                    self.status = "Not detected"
                    recogResponse.handleError()
                }
            }
        })
        
        try? VNImageRequestHandler(cgImage: cgImage).perform([request])
    }
    
    func cgImageFromURL(_ url: URL) -> CGImage? {
        guard let imageData = try? Data(contentsOf: url),
              let source = CGImageSourceCreateWithData(imageData as CFData, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
            // Error handling or logging if the image cannot be created
            return nil
        }
        
        return cgImage
    }
    
    
}



