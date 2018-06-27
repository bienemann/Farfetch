//
//  UIImageDownloader.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 27/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func load(_ from: String, animated: Bool = false) -> Void {
        
        FSHRequest(url: from, method: .get).dataResponse { response in
            
            guard
                let data = response.data,
                let image = UIImage(data: data),
                response.error == nil
            else {
                self.image = UIImage(named: "downloadImagePlaceholder")
                return
            }
            
            DispatchQueue.main.async {
                if animated {
                    self.alpha = 0.0
                    self.image = image
                    UIView.animate(withDuration: 0.5, animations: {
                        self.alpha = 1.0
                    })
                } else {
                    self.image = image
                }
            }
        }
    }
    
}
