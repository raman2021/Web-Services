//
//  DogAPIHelper.swift
//  DogBreeds
//
//  Created by mac on 2022-02-06.
//

import Foundation

struct DogAPIHelper{
    private static let baseURL = "https://dog.ceo/api/breeds/list/all"
    
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    static func fetch(callback: @escaping ([Dog]) -> Void){
        guard
            let url = URL(string: baseURL)
        else{return}
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            data, request, error in
            
            if let data = data {
                do{
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    guard
                        let jsonDictionary = jsonObject as? [AnyHashable: Any],
                        let results = jsonDictionary["message"] as? [String:Any]
                    else{preconditionFailure("was not able to parse JSON data")}
                    
                    //print(results.first!)
                    var dogList = [Dog]()
                    
                    for (key , value) in results{
                        let newDog = Dog(name: "\(key)", url: "\(value)" )
                        dogList.append(newDog)
                    }
                    
                    OperationQueue.main.addOperation {
                                            callback(dogList)
                                            }
                    
                    
                } catch let e {
                    print("could not serialize json data \(e)")
                }
            }else if let error = error {
                print("something went wrong when fetching. ERROR \(error)")
            }else {
                print("unknown error has occured")
            }
        }
        task.resume()

        
    }
}
