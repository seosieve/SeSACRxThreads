//
//  NetworkManager.swift
//  SeSACRxThreads
//
//  Created by 서충원 on 8/8/24.
//

import Foundation
import RxSwift

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    static let kobisKey = "f5c000e6df5872dbc078e614072c3b08"
    
    func callBoxOffice(_ date: Int) -> Observable<Movie> {
        let key = NetworkManager.kobisKey
        let url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(key)&targetDt=\(date)"
        
        let result = Observable<Movie>.create { observable in
            guard let url = URL(string: url) else {
                observable.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    observable.onError(APIError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299) ~= response.statusCode else {
                    observable.onError(APIError.statusError)
                    return
                }
                
                if let data = data, let movieData = try? JSONDecoder().decode(Movie.self, from: data) {
                    observable.onNext(movieData)
//                    observable.onCompleted()
                } else {
                    observable.onError(APIError.unknownResponse)
                }
            }.resume()
            
            return Disposables.create()
        }
            .debug()
        
        return result
    }
}
