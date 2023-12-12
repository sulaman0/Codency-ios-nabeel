//
//  SplashViewController.swift
//  Codency
//
//  Created by Nabeel Nazir on 21/11/2023.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateLogo()
    }
    
    private func animateLogo() {
        
        let animationView: LottieAnimationView = .init(name: "SplashLottie")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1
        
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        animationView.play { [weak self] isCompleted in
            guard let _ = self else { return }
            
            if isCompleted {
                if UserDefaultsConfig.user.isSome {
                    Commons.goToHome()
                } else {
                    Commons.goToLogin()
                }
            }
        }
    }
    
}
