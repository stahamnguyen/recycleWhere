//
//  RecyclingSpotService.swift
//  RecycleWhere
//
//  Created by iosdev on 25.04.18.
//  Copyright © 2018 Erkki Halinen. All rights reserved.
//

/*
 *
 * Notes:
 *   Service class for fetching recycling spots based on the user's location (Latitude and Longitude, WGS Decimals)
 */

import Foundation

class RecyclingSpotService {
    
    let APIBaseUrl = "http://kierratys.info/2.0/genxml.php"
    
    // MARK: Public methods
    //Fetches the nearest recycling spots. Server returns XML data
    func fetchRecyclingSpots(_ userLatitude: Float, _ userLongitude: Float) -> Data {
        
        let requestUrl:NSURL = self.constructRequestNSURL(userLatitude, userLongitude)
        
        var serverResponse: Data?
        
        let task = URLSession.shared.dataTask(with: requestUrl as URL) { (data, response, error) in
            
            guard let data = data else {
                fatalError("Error processing data from server")
            }
            serverResponse = data
        }
        task.resume()
        
        return (serverResponse ?? nil)!
    }
    
    // MARK: Private methods
    //Constructs the request URL when given latitude and longitude of the user
    private func constructRequestNSURL(_ lat: Float,_ lng: Float) -> NSURL{
        
        var url:String = APIBaseUrl
        url.append("?lat=" + String(lat))
        url.append("&lng=" + String(lng))
        
        print(url)
        
        return NSURL(string: url)!
    }
}
