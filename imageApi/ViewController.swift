//
//  ViewController.swift
//  imageApi
//
//  Created by N S on 19.10.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "people")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        setupConstraints()
        
        postAPI()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
    }
    
    func postAPI() {
        let headers = [
            "content-type": "multipart/form-data; boundary=---011000010111000001101001",
            "X-RapidAPI-Key": "b17fb37ff3msh2a4c5dfe99530d0p1c86a6jsndfc55e574713",
            "X-RapidAPI-Host": "universal-background-removal.p.rapidapi.com"
        ]
        
        guard let imageData = imageView.image?.pngData() else {
            print("Unable to convert image to data")
            return
        }
        
        let parameters = [
            [
                "name": "image",
                "fileName": "people.jpeg",
                "contentType": "application/octet-stream",
                "file": imageData
            ]
        ]
        
        let boundary = "---011000010111000001101001"
        
        var body = Data()
        
        for param in parameters {
            let paramName = param["name"]!
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition:form-data; name=\"\(paramName)\"; filename=\"\(param["fileName"]!)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(param["contentType"]!)\r\n\r\n".data(using: .utf8)!)
            body.append(param["file"] as! Data)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        guard let url = URL(string: "https://universal-background-removal.p.rapidapi.com/cutout/universal/common-image") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                print("JSON", json)
            } catch {
                print("ERROR", error)
            }
        }
        
        dataTask.resume()
    }
}
