//
//  ImageApi.swift
//  imageApi
//
//  Created by N S on 19.10.2023.
//

import Foundation

class ImageApi {
    /*func post() {
        let headers = [
            "content-type": "multipart/form-data; boundary=---011000010111000001101001",
            "X-RapidAPI-Key": "b5bf1d4d9bmsh97142a47ad9c23bp11d9b4jsn591d0d82708f",
            "X-RapidAPI-Host": "universal-background-removal.p.rapidapi.com"
        ]
        let parameters = [
            [
                "name": "image",
                "fileName": "image.jpeg",
                "contentType": "application/octet-stream",
                "file": "[object File]"
            ]
        ]

        let boundary = "---011000010111000001101001"

        var body = ""
        var error: NSError? = nil
        var fileContent: String?
        for param in parameters {
            let paramName = param["name"]!
            body += "--\(boundary)\r"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if let filename = param["fileName"] {
                let contentType = param["content-type"]!
                do {
                    fileContent = try String(contentsOfFile: filename, encoding: String.Encoding.utf8)
                } catch {
                    print("error in file content")
                }
                if (error != nil) {
                    print(error as Any)
                }
                body += "; filename=\"\(filename)\"\r"
                body += "Content-Type: \(contentType)\r\r"
                body += fileContent ?? ""
            } else if let paramValue = param["value"] {
                body += "\r\r\(paramValue)"
            }
        }

        let request = NSMutableURLRequest(url: NSURL(string: "https://universal-background-removal.p.rapidapi.com/cutout/universal/common-image")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
            request.httpBody = requestBody
        } catch {
            debugPrint("request error")
        }

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
        })

        dataTask.resume()
    }*/
    
    func post() {
        
        
        
        struct Parameter {
            let name: String
            let fileName: String?
            let contentType: String?
            let file: String?
            let value: String?
        }

        func sendRequest() {
            let headers = [
                "content-type": "multipart/form-data; boundary=---011000010111000001101001",
                "X-RapidAPI-Key": "b5bf1d4d9bmsh97142a47ad9c23bp11d9b4jsn591d0d82708f",
                "X-RapidAPI-Host": "universal-background-removal.p.rapidapi.com"
            ]
            
            let parameters = [
                Parameter(name: "people", fileName: "people.jpeg", contentType: "application/octet-stream", file: "[object File]", value: nil)
            ]
            
            let boundary = "---011000010111000001101001"
            
            var request = URLRequest(url: URL(string: "https://universal-background-removal.p.rapidapi.com/cutout/universal/common-image")!,
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            
            let body = NSMutableData()
            
            for param in parameters {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                
                if let paramName = param.fileName {
                    let contentType = param.contentType!
                    if let fileURL = Bundle.main.url(forResource: "people", withExtension: "jpeg") {
                        if let fileData = try? Data(contentsOf: fileURL) {
                            let fileContent = String(data: fileData, encoding: .utf8)
                            body.append("Content-Disposition: form-data; name=\"\(param.name)\"; filename=\"\(paramName)\"\r\n".data(using: .utf8)!)
                            body.append("Content-Type: \(contentType)\r\n\r\n".data(using: .utf8)!)
                            body.append(fileContent!.data(using: .utf8)!)
                        }
                    }
                } else if let paramValue = param.value {
                    body.append("\r\n\r\n\(paramValue)".data(using: .utf8)!)
                }
            }
            
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = body as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error)
                } else {
                    if let httpResponse = response as? HTTPURLResponse {
                        print(httpResponse)
                    }
                }
            }
            
            dataTask.resume()
        }
    }
}
