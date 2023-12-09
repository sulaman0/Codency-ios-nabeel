//
//  Common.swift
//  Codency
//
//  Created by Nabeel Nazir on 04/12/2023.
//

import UIKit
import Lottie

final class Commons: NSObject {
    private static let ActivityViewTag = 121
    private static let LoaderBGView = 122
    
    class func showActivityIndicator() -> Void {
        
        let animationView: LottieAnimationView = .init(name: "Loader")
        animationView.tag = ActivityViewTag
        animationView.backgroundColor = .clear

        let icon = UIImage(named: "AppLogo")
        let iconView = UIImageView(image: icon)
        iconView.contentMode = .scaleAspectFit
        
        if let window = UIApplication.shared.windows.first {

            let BGView = UIView()
            BGView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            BGView.tag = LoaderBGView
            BGView.frame = window.frame

            if let bgView = window.viewWithTag(LoaderBGView) {
                bgView.removeFromSuperview()
            }

            if let activityView = window.viewWithTag(ActivityViewTag)
            {
                activityView.removeFromSuperview()
            }

            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.animationSpeed = 1

            window.addSubview(BGView)

            window.addSubview(animationView)
            animationView.addSubview(iconView)

            animationView.translatesAutoresizingMaskIntoConstraints = false
            animationView.widthAnchor.constraint(equalToConstant: 110).isActive = true
            animationView.heightAnchor.constraint(equalToConstant: 110).isActive = true
            animationView.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
            animationView.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
            
            iconView.translatesAutoresizingMaskIntoConstraints = false
            iconView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            iconView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            iconView.centerXAnchor.constraint(equalTo: animationView.centerXAnchor).isActive = true
            iconView.centerYAnchor.constraint(equalTo: animationView.centerYAnchor).isActive = true

            // 6. Play animation
            animationView.play()

        }
    }
    
    class func hideActivityIndicator() -> Void {
        if let window = UIApplication.shared.windows.first {
            if let activityView = window.viewWithTag(ActivityViewTag) {
                // activityView.hideLoading()
                activityView.removeFromSuperview()
            }
            if let bgView = window.viewWithTag(LoaderBGView) {
                bgView.removeFromSuperview()
            }
        }
    }
    
    static func showError(controller: UIViewController, message: String) {
    }
}
