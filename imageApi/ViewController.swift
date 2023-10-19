//
//  ViewController.swift
//  imageApi
//
//  Created by N S on 19.10.2023.
//

import UIKit
//7 34

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
       
        guard let url = URL(string: "https://universal-background-removal.p.rapidapi.com/cutout/universal/common-image") else {
            print("url is wrong")
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        let headers = [
            "content-type": "multipart/form-data; boundary=---011000010111000001101001",
            "X-RapidAPI-Key": "b5bf1d4d9bmsh97142a47ad9c23bp11d9b4jsn591d0d82708f",
            "X-RapidAPI-Host": "universal-background-removal.p.rapidapi.com"
        ]
        
        request.allHTTPHeaderFields = headers
        request.httpMethod = "POST"
        
        //[[String : String]] array of dictionaries
        let requestObject = [
            [
                "name": "image",
                "fileName": "people",
                "contentType": "application/octet-stream",
                "file": "[object File]"
            ]
        ]
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: requestObject, options: .fragmentsAllowed)
            request.httpBody = requestBody
        } catch {
            debugPrint("request error")
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            //json parsing
            do {
                guard let data = data else { return }
                let parsingData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                print(parsingData)
            } catch {
                debugPrint("parsing with error")
            }
        }
        
        dataTask.resume()
    }
}

