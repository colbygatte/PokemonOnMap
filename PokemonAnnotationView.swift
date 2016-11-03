//
//  PokemonAnnotationView.swift
//  UsingMaps
//
//  Created by Colby Gatte on 11/1/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import MapKit

class PokemonAnnotationView: MKAnnotationView {

    var annotationImage: UIImage!
    var annotationImageView: UIImageView!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        annotationImage = UIImage()
        annotationImageView = UIImageView()
        
    }
    
    func addImageToView() {
        self.annotationImageView.image = self.annotationImage
        self.annotationImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        self.addSubview(annotationImageView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
