//
//  MuseumAPIClient.swift
//  MuseumAPI
//
//  Created by Stephanie Ramirez on 12/28/18.
//  Copyright © 2018 Stephanie Ramirez. All rights reserved.
//

import Foundation

final class MuseumAPIClient {
    
    static func searchEvents(keyword: Int, completionHandler: @escaping (AppError?, ObjectData?) -> Void) {
        let urlString = "https://collectionapi.metmuseum.org/public/collection/v1/objects/\(keyword)"
        NetworkHelper.shared.performDataTask(endpointURLString: urlString, httpMethod: "GET", httpBody: nil) { (error, data, response) in
            if let error = error {
                completionHandler(error, nil)
            } else if let data = data {
                do {
                    let objectData = try JSONDecoder().decode(ObjectData.self, from: data)
                    completionHandler(nil, objectData)
                } catch {
                    completionHandler(AppError.decodingError(error), nil)
                }
            }
        }
    }
    
    static func getObjectIds(completionHandler: @escaping(AppError?, [Int]?) -> Void) {
        let myUrl = "https://collectionapi.metmuseum.org/public/collection/v1/objects"
        NetworkHelper.shared.performDataTask(endpointURLString: myUrl, httpMethod: "GET", httpBody: nil) { (error, data, response) in
            if let error = error {
                completionHandler(error, nil)
            } else if let data = data {
                do {
                    let objectData = try JSONDecoder().decode(ObjectIDs.self, from: data)
                    completionHandler(nil, objectData.objectIDs)
                } catch {
                    completionHandler(AppError.decodingError(error), nil)
                }
            }
        }
    }
    
    
    static func favoriteObject(data: Data, completionHandler: @escaping (AppError?, Bool) -> Void) {
        NetworkHelper.shared.performUploadTask(endpointURLString: "https://5c2d2438b8051f0014cd475a.mockapi.io/api/v1/favorites", httpMethod: "POST", httpBody: data) { (appError, data, httpResponse) in
            if let appError = appError {
                completionHandler(appError, false)
            }
            guard let response = httpResponse,
                (200...299).contains(response.statusCode) else {
                    let statusCode = httpResponse?.statusCode ?? -999
                    completionHandler(AppError.badURL(String(statusCode)), false)
                    return
            }
            if let _ = data {
                completionHandler(nil, true)
            }
        }
    }
    
    static func getFavorites(name: String, completionHandler: @escaping (AppError?, [Favorite]?) -> Void) {
        let getFavoritesEndpoint = "https://5c2d2438b8051f0014cd475a.mockapi.io/api/v1/favorites?search=\(name)"
        NetworkHelper.shared.performDataTask(endpointURLString: getFavoritesEndpoint, httpMethod: "GET", httpBody: nil) { (appError, data, httpResponse) in
            if let appError = appError {
                completionHandler(appError, nil)
            }
            guard let response = httpResponse,
                (200...299).contains(response.statusCode) else {
                    let statusCode = httpResponse?.statusCode ?? -999
                    completionHandler(AppError.badURL(String(statusCode)), nil)
                    return
            }
            if let data = data {
                do {
                    let favorites = try JSONDecoder().decode([Favorite].self, from: data)
                    completionHandler(nil, favorites)
                } catch {
                    completionHandler(AppError.decodingError(error), nil)
                }
            }
        }
    }
}
