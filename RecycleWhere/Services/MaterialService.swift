//
//  MaterialService.swift
//  RecycleWhere
//
//  Created by iosdev on 25.04.18.
//  Copyright © 2018 Staham Nguyen. All rights reserved.
//

import Foundation

class MaterialService {
    
    //Base URL for the back-end, modify when building end product with actual server IP
    let baseurl = "http://localhost:3000"
    
    //User defaults instance
    let userDefaults = UserDefaults.standard
    
    // MARK: Category fetching function
    func getCategories() {
        
        print("getCategories")
        
        //Fetch categories ONLY if the categories aren't already stored.
        if self.userDefaults.object(forKey: "materials") == nil {
            
            print("Categories not found, fetching from server: ")
            
            let url = URL(string: String(baseurl + "/categories"))!
            print(url)
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                //Don't continue if error happens
                if let error = error {
                    print(error)
                    return
                }
                
                //If a server-side error happens, don't continue
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                        print("Error")
                        return
                }
                
                // MARK: JSON Handling scope
                if let mimeType = httpResponse.mimeType, mimeType == "application/json",
                    let data = data {
                    
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any];
                    
                    guard let materials = json?["categories"] as? [String] else {
                        fatalError("Couldn't get the categories from the server !")
                    }
                    
                    //Store materials array into UserDefaults
                    self.userDefaults.setValue(materials, forKey: "materials")
                    print("Categories saved to device")
                    
                }
            }
            
            task.resume()
            
        } else {
            print("Categories found")
        }
    }
}
