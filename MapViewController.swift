//
//  MapViewController.swift
//  UsingMaps
//
//  Created by Colby Gatte on 11/1/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var pokemon = [Int:Pokemon]()
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocationCoordinate2D!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let apiURL = URL(string: "https://still-wave-26435.herokuapp.com/pokemon/all")!

        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone // are you confined by some distance?
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestAlwaysAuthorization()
        
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        // zooming
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 29.73, longitude: -95.39)
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegionMake(coordinate, span)
        self.mapView.setRegion(region, animated: true)
        
        URLSession.shared.dataTask(with: apiURL) { (data: Data?, response: URLResponse?, error: Error?) in
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [[String:Any]]
            
            for var result in json {
                let poke = Pokemon()
                poke.imageURL = URL(string: result["imageURL"] as! String)!
                poke.latitude = result["latitude"] as! Double
                poke.longitude = result["longitude"] as! Double
                poke.name = result["name"] as! String
                
                let id = result["id"] as! Int
                
                self.pokemon[id] = poke
            }
            
            
            DispatchQueue.main.async {
                for (id, poke) in self.pokemon {
                    
                    
                    let pokePointAnnotation = MKPointAnnotation()
                    pokePointAnnotation.coordinate = CLLocationCoordinate2DMake(poke.latitude, poke.longitude)
                    pokePointAnnotation.title = "\(id)"
                    
                    self.mapView.addAnnotation(pokePointAnnotation)
                    
                }
            }
            
        }.resume()
        
        
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = (manager.location?.coordinate)!
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        
        // why does annotation.title have to be unwwrapped twice?
        let pokeId = Int(annotation.title!!)!
        let poke = pokemon[pokeId]!
        
        let pokemonAnnotationView = PokemonAnnotationView(annotation: annotation, reuseIdentifier: "PokemonAnnotationView\(pokeId)")
        
        URLSession.shared.dataTask(with: poke.imageURL) { (data: Data?, response: URLResponse?, error: Error?) in
            
            pokemonAnnotationView.annotationImage = UIImage(data: data!)
            DispatchQueue.main.async {
                pokemonAnnotationView.addImageToView()
            }
            
            
        }.resume()
        
        return pokemonAnnotationView
    }

    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        if let annotationView = views.first {
            if let annotation = annotationView.annotation {
                if annotation is MKUserLocation {
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                    self.mapView.setRegion(region, animated: true)
                }
            }
        }
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewPokemon" {
            let addNewPokemonVC = segue.destination as! AddNewPokemonViewController
            addNewPokemonVC.currentLocation = self.currentLocation
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

}
