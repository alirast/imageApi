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
    
    private lazy var newImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        postAPI()
    }
    
    private func configureUI() {
        view.addSubview(imageView)
        view.addSubview(newImageView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
        
        NSLayoutConstraint.activate([
            newImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newImageView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            newImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            newImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            newImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }
    
    private func postAPI() {
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
                
                self.parseJSON(json: json)
                
                
            } catch {
                print("ERROR", error)
            }
        }
        
        dataTask.resume()
    }
    
    private func parseJSON(json: Any) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json),
              let response = try? JSONDecoder().decode(JSONResponse.self, from: jsonData),
              let imageURL = URL(string: response.data.imageUrl) else {
            return
        }
        
        do {
            let imageData = try Data(contentsOf: imageURL)
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.newImageView.image = image
            }
        } catch {
            print("failed to load image")
        }
    }
}
