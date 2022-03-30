//
//  Networking.swift
//  MVVM
//
//  Created by Gulam Ali on 30/03/22.
//

import Foundation
import UIKit

enum CustomError : Error {
    case noInternet
    case errorfetchingData
    case badStatusCode
    case noData
    case keyNotFound
    case ValueNotFound
    case typeMismatch
    case other
}


class Networking {
    
    static let shared = Networking()
    
    private init(){}
        
    func MakeGetRequest<T:Decodable>(Url:String,completion:@escaping (Result<T,CustomError>) -> ()){
        
        
        if !CheckConnection.isConnectedToNetwork(){
            print("No internet")
            completion(.failure(.noInternet))
            return
        }else{
            let url = URL(string: "\(Url)")!
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                let urlString = request.url?.absoluteString ?? "No String"
                
                if let error = error {
                    print("Error fetching data from \(urlString): \n\(error)")
                    completion(.failure(.errorfetchingData))
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    let statusCode = response.statusCode
                    if statusCode != 200 {
                        print("Bad status code: \(statusCode)")
                        completion(.failure(.badStatusCode))
                        return
                    }
                }
                
                guard let data = data else {
                    print("No data from request with url: \(urlString)")
                    completion(.failure(.noData))
                    return
                }
                
                do{
                    let dataa = try JSONDecoder().decode(T.self, from: data)
                    print(dataa)
                    completion(.success(dataa))
                    
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                    completion(.failure(.other))
                    return
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    completion(.failure(.keyNotFound))
                    return
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    completion(.failure(.ValueNotFound))
                    return
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    completion(.failure(.typeMismatch))
                    return
                } catch {
                    print("error: ", error)
                    completion(.failure(.other))
                    return
                }
                
            }.resume()
        }
    
    }
    
}


