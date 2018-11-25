//
//  Sinais.swift
//  SemaforoApp
//
//  Created by Pedro Clericuzi on 23/11/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import Foundation

struct Sinais {
    let id : Int
    let lat : Double
    let long : Double
    let sinalsonoro : String
    let utilizacao : String
    let localizacao1 : String
    
    init(id:Int, lat: Double, long: Double, sinalsonoro:String, utilizacao:String, localizacao1:String) {
        self.id = id
        self.lat = lat
        self.long = long
        self.sinalsonoro = sinalsonoro
        self.utilizacao = utilizacao
        self.localizacao1 = localizacao1
    }
}
