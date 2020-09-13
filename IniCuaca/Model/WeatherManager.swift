//
//  WeatherManager.swift
//  IniCuaca
//
//  Created by IndratS on 12/09/20.
//  Copyright © 2020 IndratSaputra. All rights reserved.
//

import Foundation
import Alamofire

enum filterAPI {
    case CurrentLocation
    case ByCity
}

struct WeatherManager {
    
    let apiKEY = WeatherAPI.apiKEY
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?"
    
    
   
    func getParams(param: [String: String]) -> [String: String]{
        var params: [String : String] = [:]
        params = param
        params["appid"] = apiKEY
        
        return params
    }
    
    
    func getURL(coordinate: [String:String], completion: @escaping(Result<WeatherModel, Error>) -> Void){
        let params = getParams(param: coordinate)
        guard let url = URL(string: baseURL) else {return}
        
        AF.request(url
            , method: .get
            , parameters: params
        ).response { reponse in
            switch reponse.result {
            case .success(let data):
                if let data = data {
                    if let result = self.parsingJSON(data: data) {
                        completion(.success(result))
                    }
                }
                
            case .failure(let err):
//                print(err)
                completion(.failure(err))
            }
        }
    }
    
    func parsingJSON(data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decoderData = try decoder.decode(WeatherModel.self, from: data)
            return decoderData
            
        }catch let err {
            print(err)
            return nil
        }
    }
    
}
