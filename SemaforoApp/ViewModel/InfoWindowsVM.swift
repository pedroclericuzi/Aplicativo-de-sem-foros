//
//  InfoWindowsVM.swift
//  SemaforoApp
//
//  Created by Pedro Clericuzi on 25/11/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit
import GoogleMaps

class InfoWindowsVM {
    
    //Com esse método eu pego informações da posição atual do usuário
    func infosLocal(from location: CLLocation, completion: @escaping (_ cidade: String?, _ pais:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
}
