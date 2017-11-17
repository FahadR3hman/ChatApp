//
//  ImageCircle.swift
//  Indalen
//
//  Created by Fahad Rehman on 12/2/16.
//  Copyright © 2016 Codecture. All rights reserved.
//

import UIKit

class ImageCircle: UIImageView {

    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

}
