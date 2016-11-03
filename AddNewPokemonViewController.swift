//
//  AddNewPokemonViewController.swift
//  UsingMaps
//
//  Created by Colby Gatte on 11/2/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import MapKit

class AddNewPokemonViewController: UIViewController {

    var currentLocation: CLLocationCoordinate2D!
    var apiURL: URL!
    
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var imageURLTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        latitudeLabel.text = String(currentLocation.latitude)
        longitudeLabel.text = String(currentLocation.longitude)
        
        apiURL = URL(string: "https://still-wave-26435.herokuapp.com/pokemon/")

    }
    
    @IBAction func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addButtonPressed() {
        
        let poke = Pokemon()
        poke.imageURL = URL(string: imageURLTextField.text!)!
        poke.latitude = currentLocation.latitude
        poke.longitude = currentLocation.longitude
        poke.name = nameTextField.text
        
        //{"name":"POKEMAN NEW 100","imageURL":"someImageURL","latitude":11,"longitude":99}
        let test: [String: Any] = ["name": poke.name,
                    "imageURL": poke.imageURL.absoluteString,
                    "latitude": poke.latitude,
                    "longitude": poke.longitude]
        
        let json = try! JSONSerialization.data(withJSONObject: test, options:[])
        let jsonString = String(data: json, encoding: .utf8)
        
        
        apiURL = URL(string: "https://still-wave-26435.herokuapp.com/pokemon")
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonString?.data(using: .utf8)
        
        print(jsonString!)
        print("######")
        
        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data, error == nil else { // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 { // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }.resume()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
