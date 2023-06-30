//
//  SpinnerView.swift
//  RadiusAgent
//
//  Created by NFC User on 30/06/23.
//

import UIKit

class SpinnerView: UIActivityIndicatorView {
    
    static let shared = SpinnerView(style: .large)
    
    override init(style: UIActivityIndicatorView.Style) {
            super.init(style: style)
            self.color = .gray // Set the color of the spinner
            self.hidesWhenStopped = true // Hide the spinner when it's not animating
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func startAnimating(in view: UIView) {
           self.center = view.center
           view.addSubview(self)
           self.startAnimating()
       }

}
