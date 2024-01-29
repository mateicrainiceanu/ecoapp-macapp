//
//  ContentView.swift
//  dspimagerecognition
//
//  Created by Matei Crăiniceanu on 16.01.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State public var textFieldInput: String = "http://localhost:8000"
    @State public var running: Bool = false
    
    @State var handler = Handler(serverURL: "")
    
    var body: some View {
        VStack {
                HStack{
                    Text("Status: \(running ? "Started" : "Stopped")")
                    Circle()
                        .foregroundColor((running ? .green : .red))
                          .frame(width: 10, height: 10)
                          .padding(.trailing, 8)
                }.frame(maxWidth: .infinity, alignment: .leading)
            

                    Text("Filename: \(handler.filename)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 5)

            Text("Req Status: \(handler.status)")
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 5)

            
            TextField("Enter server adress here", text: $textFieldInput)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())


            HStack{
                Button("\("Start") recognizing", action: {
                    running = true
                    handler.serverURL=textFieldInput
                    handler.running = true
                    print("Starting")
                    print(textFieldInput)
                })
                Button("\("Stop") recognizing", action: {
                    handler.running=false
                    running = false
                })
            }


            
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
