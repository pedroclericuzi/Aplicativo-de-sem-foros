//
//  Semaforos.swift
//  SemaforoApp
//
//  Created by Pedro Clericuzi on 23/11/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import Foundation

struct DecodeJson: Decodable {
    let sinais: [meusSemaforos]
    enum CodingKeys : String, CodingKey {
        case sinais = "records"
    }
}

struct meusSemaforos: Decodable {
    let _id : Int
    let Latitude : String
    let Longitude : String
    let sinalsonoro : String
    let utilizacao : String
    let localizacao1 : String
}

class SemaforosLista {
    let url = "http://desafio.serttel.com.br/dadosRecifeSemaforo.json"
    func parsingJSON(filtrar:String, completion: @escaping ([Sinais]) -> Void){
        var arrSinais:[Sinais] = []
        let url = URL(string: self.url)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, err) in
            guard let data = data else {return}
            
            do {
                let myJson = try JSONDecoder().decode(DecodeJson.self, from: data)
                for sinais in myJson.sinais {
                    let lat = Double(sinais.Latitude)
                    let long = Double(sinais.Longitude)
                    
                    //Verifico se há alguma filtragem
                    if(filtrar==sinais.sinalsonoro || filtrar=="none"){
                        arrSinais.append(Sinais(id: sinais._id, lat: lat ?? 0, long: long ?? 0, sinalsonoro: sinais.sinalsonoro, utilizacao: sinais.utilizacao, localizacao1: sinais.localizacao1))
                    }
                    
                }
                completion(arrSinais)
            } catch let erro {
                print ("Erro: \(erro)");
            }
        }
        task.resume()
    }
}
