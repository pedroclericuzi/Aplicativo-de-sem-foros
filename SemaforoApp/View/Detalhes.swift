//
//  Detalhes.swift
//  SemaforoApp
//
//  Created by Pedro Clericuzi on 25/11/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit

class Detalhes: UIViewController {
    var labelUtilizacao:UILabel?
    var labelLocalizacao:UILabel?
    var labelSinalsoro:UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Detalhes sinal \(arraySinal[0].id)" //Aqui eu estou acessando o array global para recuperar o id do sinal
        view.backgroundColor = UIColor.white
        self.itensDetalhes()
    }
    
    func itensDetalhes() -> Void {
        
        let screenSize: CGRect = UIScreen.main.bounds
        self.labelUtilizacao = UILabel(frame: CGRect(x: 10,
                                               y: 100,
                                               width: screenSize.width * 0.6,
                                               height: 18))
        self.labelUtilizacao?.font = UIFont(name: "Halvetica", size: 17)
        self.labelUtilizacao?.text = "Utilização: \(arraySinal[0].utilizacao)" //Aqui eu estou acessando o array global para recuperar os dados do sinal selecionado
        self.labelUtilizacao?.textColor = UIColor.black
        self.view.addSubview(self.labelUtilizacao!)
        
        self.labelLocalizacao = UILabel(frame: CGRect(x: 10,
                                               y: 140,
                                               width: screenSize.width,
                                               height: 18))
        self.labelLocalizacao?.font = UIFont(name: "Halvetica", size: 17)
        self.labelLocalizacao?.text = "Localização: \(arraySinal[0].localizacao1)" //Aqui eu estou acessando o array global para recuperar os dados do sinal selecionado
        self.labelLocalizacao?.textColor = UIColor.black
        self.view.addSubview(self.labelLocalizacao!)
        
        self.labelSinalsoro = UILabel(frame: CGRect(x: 10,
                                               y: 180,
                                               width: screenSize.width * 0.6,
                                               height: 18))
        self.labelSinalsoro?.font = UIFont(name: "Halvetica", size: 17)
        self.labelSinalsoro?.text = "Sinalsoro: \(arraySinal[0].sinalsonoro)" //Aqui eu estou acessando o array global para recuperar os dados do sinal selecionado
        self.labelSinalsoro?.textColor = UIColor.black
        self.view.addSubview(self.labelSinalsoro!)
    }
}
