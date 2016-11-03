//
//  PostViewController.swift
//  UsingMaps
//
//  Created by Colby Gatte on 11/2/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    @IBOutlet var textView: UITextView!
    
    
    @IBAction func requestButtonPressed() {
        textView.text = ""
        
        let test: [String:String] = ["name":"colby", "occupation":"developer", "age":"25"]
        let testJson = try! JSONSerialization.data(withJSONObject: test, options: [])
        
        
        let url = URL(string: "http://colbyg.com/post/post.cgi")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = testJson
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                self.textView.text = String(data: data!, encoding: .utf8)
            }
            
            
        }.resume()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
