//
//  ViewController.swift
//  SemaforoApp
//
//  Created by Pedro Clericuzi on 22/11/2018.
//  Copyright © 2018 Pedro Clericuzi. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

var arraySinal:[Sinais] = []
class ViewController: UIViewController, GMSMapViewDelegate {
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var tappedMarker = GMSMarker()
    
    var meusSinais:[Sinais] = []
    
    let semaforosLista = SemaforosLista()
    var infoWindow = DetailsView()
    var currentWinLocation = CurrentLocView()
    let infoWindowsVM = InfoWindowsVM()
    
    let currentLocationMarker = GMSMarker()
    var indexWindow:Int?
    
    var myMap: GMSMapView?
    
    var latAtual:Double?
    var longAtual:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Início"
        
        locManager.requestWhenInUseAuthorization()
        
        //Verifico se o usuário autorizou o acesso as informações referentes ao mapa
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            iconeFiltrar ()
            guard let currentLocation = locManager.location else {
                return
            }
            latAtual = currentLocation.coordinate.latitude
            longAtual = currentLocation.coordinate.longitude
            
            let camera = GMSCameraPosition.camera(withLatitude: latAtual!, longitude: longAtual!, zoom: 16.0)
            self.myMap = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            self.myMap!.delegate=self
            
            gerarSinais(filtro: "none")
        }
    }
    
    func gerarSinais(filtro:String) {
        view = self.myMap
        self.inserirPino(i: -1, pin: "pin", lat: latAtual!, long: longAtual!, map: self.myMap!) //Coloco o pino na posição atual do usuário
        
        //Chamo o método parsingJSON para recuperar os dados dos sinais
        DispatchQueue.global(qos: .background).async {
            self.semaforosLista.parsingJSON(filtrar:filtro) {(output) in
                for outSinais in output {
                    self.meusSinais.append(Sinais(id: outSinais.id, lat: outSinais.lat, long: outSinais.long, sinalsonoro: outSinais.sinalsonoro, utilizacao: outSinais.utilizacao, localizacao1: outSinais.localizacao1))
                    
                    self.inserirPino(i: outSinais.id, pin: "traffic-light", lat: outSinais.lat, long: outSinais.long, map: self.myMap!)
                }
            }
        }
    }
    
    func inserirPino (i:Int, pin:String, lat:Double, long:Double, map:GMSMapView){
        let markerImage = UIImage(named: pin)!.withRenderingMode(.alwaysTemplate)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.map = map
        marker.icon = markerImage
        marker.accessibilityLabel = "\(i)"
    }
    
    class func nibWinDetalhes() -> DetailsView {
        return UINib(nibName: "infoWinDetalhes", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DetailsView
    }
    
    class func nibCurrentLoc() -> CurrentLocView {
        return UINib(nibName: "infoWinCurrentLoc", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CurrentLocView
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        self.indexWindow = Int(marker.accessibilityLabel!)
        let location = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
        
        if(self.indexWindow!>=0){
            tappedMarker = marker
            infoWindow.removeFromSuperview()
            infoWindow = ViewController.nibWinDetalhes() //Inicializando o respectivo .XIB para setar as informações para ele
            infoWindow.title.text = "Sinal \(indexWindow!)"
            infoWindow.center = mapView.projection.point(for: location)
            infoWindow.center.y = infoWindow.center.y - 90
            infoWindow.btDetalhes.addTarget(self, action: #selector(btVerDetalhes), for: .touchUpInside)
            self.view.addSubview(infoWindow)
        } else {
            tappedMarker = marker
            currentWinLocation.removeFromSuperview()
            currentWinLocation = ViewController.nibCurrentLoc() //Inicializando o respectivo .XIB para setar as informações para ele
            let locationCL = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
            //Pego dados da localização atual para inserir no InfoWindows
            infoWindowsVM.infosLocal(from: locationCL) { cidade, pais, error in
                guard let cidade = cidade, let pais = pais, error == nil else { return }
                self.currentWinLocation.labelLoc.text = cidade + ", " + pais
            }
            currentWinLocation.center = mapView.projection.point(for: location)
            currentWinLocation.center.y = currentWinLocation.center.y - 70
            self.view.addSubview(currentWinLocation)
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        let location = CLLocationCoordinate2D(latitude: tappedMarker.position.latitude, longitude: tappedMarker.position.longitude)
        infoWindow.center = mapView.projection.point(for: location)
        infoWindow.center.y = infoWindow.center.y - 90
        
        currentWinLocation.center = mapView.projection.point(for: location)
        currentWinLocation.center.y = currentWinLocation.center.y - 70
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoWindow.removeFromSuperview()
        currentWinLocation.removeFromSuperview()
    }
    
    //Insere o botão de filtrar no navigationbar
    func iconeFiltrar (){
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "funnel"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(btFiltrar), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.rightBarButtonItems = [item1]
    }
    
    //Método chamado quando o usuário clicar em "Ver detalhes" no InfoWindows dos Sinais de trânsito
    @objc func btVerDetalhes(sender: UIButton) {
        arraySinal = [meusSinais[indexWindow!-1]] //Criando um array global para acessar na tela de ver detalhes
        let detalhes = Detalhes()
        self.navigationController?.pushViewController(detalhes, animated: false)
    }
    
    @objc func btFiltrar(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Filtrar", message: "Escolha um sinalsoro", preferredStyle: .alert)
        
        let sSinalsoro = UIAlertAction(title: "S", style: .default) { (action) in
            self.myMap!.clear()//Removendo todas as informações do mapa
            self.gerarSinais(filtro: "S")//inserindo novamente aplicando o filtro
        }
        alertController.addAction(sSinalsoro)
        
        let nSinalsoro = UIAlertAction(title: "N", style: .default) { (action) in
            self.myMap!.clear()//Removendo todas as informações do mapa
            self.gerarSinais(filtro: "N")//inserindo novamente aplicando o filtro
        }
        alertController.addAction(nSinalsoro)
        
        let todos = UIAlertAction(title: "todos", style: .default) { (action) in
            self.myMap!.clear()//Removendo todas as informações do mapa
            self.gerarSinais(filtro: "none")//inserindo novamente aplicando o filtro
        }
        alertController.addAction(todos)
        
        self.present(alertController, animated: true) {}
    }
    
}

