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
    
    static func showOptionsAlertAction(message: String,
                                       negativeActionTitle: String,
                                       positiveActionTitle: String,
                                       negativeCompletionHandler: @escaping () -> Void,
                                       positiveCompletionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "Codency", message: message, preferredStyle: .alert)
        
        // Create the actions
        alertController.addAction(UIAlertAction(title: negativeActionTitle, style: .cancel, handler: { action in
            negativeCompletionHandler()
        }))
        
        alertController.addAction(UIAlertAction(title: positiveActionTitle, style: .default, handler: { action in
            positiveCompletionHandler()
        }))
      
        if let window = UIApplication.shared.windows.first {
            window.rootViewController?.present(alertController, animated: true, completion: nil)
        } else {
            UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func showError(controller: UIViewController, message: String) {
        let mainView = UIView()
        mainView.backgroundColor = UIColor.appRed
        mainView.cornerRadius = 8
        let toastLabel = UILabel()
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.GothamRegular?.withSize(15)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        mainView.addSubview(toastLabel)
        controller.view.addSubview(mainView)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.topAnchor.constraint(equalTo: mainView.topAnchor,
                                        constant: 10).isActive = true
        toastLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor,
                                        constant: -10).isActive = true
        toastLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor,
                                        constant: 10).isActive = true
        toastLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor,
                                        constant: 10).isActive = true
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.topAnchor.constraint(equalTo: controller.view.topAnchor,
                                        constant: Commons.getSafeAreaInsets().top + 20).isActive = true
        mainView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor,
                                        constant: 20).isActive = true
        mainView.widthAnchor.constraint(equalToConstant: controller.view.frame.width - 40).isActive = true
        
        UIView.animate(withDuration: 1.0, delay: 2, options: .curveEaseOut, animations: {
            mainView.alpha = 0.0
        }, completion: {(isCompleted) in
            mainView.removeFromSuperview()
        })
    }
    
    static func getSafeAreaInsets() -> UIEdgeInsets {
        let window = UIApplication.shared.windows[0]
        return window.safeAreaInsets
    }

    static func goToHome() {
        if let vc: TabbarViewController = UIStoryboard.initiate(storyboard: .main) {
            let navVC = UINavigationController(rootViewController: vc)
            navVC.setNavigationBarHidden(true, animated: true)
            UIApplication.shared.windows.first?.rootViewController = navVC
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    static func goToLogin() {
        if let vc: LoginViewController = UIStoryboard.initiate(storyboard: .auth) {
            let navVC = UINavigationController(rootViewController: vc)
            navVC.setNavigationBarHidden(true, animated: true)
            UIApplication.shared.windows.first?.rootViewController = navVC
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
}
