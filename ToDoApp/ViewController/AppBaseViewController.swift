//
//  AppBaseViewController.swift
//  ToDoApp
//
//  Created by Abhisek K. on 24/06/20.
//  Copyright © 2020 Abhisek K. All rights reserved.
//

import UIKit

class AppBaseViewController: UIViewController {
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        hideKeyboardWhenTappedAround()
        
        //        GlobalUtil.enableScreen()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        
        
        if let navigation = self.presentedViewController as? UINavigationController {
            if let visibleController = navigation.visibleViewController {
                if let nibName = visibleController.nibName {
                    
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.endEditing(true)
        
        setStatusBarAppearanceBasedOnTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        setLightContentStatusBar()
        
        //        setStatusBarAppearanceBasedOnTheme()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setStatusBarAppearanceBasedOnTheme()
    }
    
    fileprivate func setStatusBarAppearanceBasedOnTheme() {
        guard UIApplication.shared.applicationState == .inactive else {
            return
        }
        
        if isDarkMode {
            setDarkContentStatusBar()
        } else {
            setLightContentStatusBar()
        }
    }
    
    fileprivate func setLightContentStatusBar() {
        self.setStatusBarBackgroundColor(.white)
    }
    
    fileprivate func setDarkContentStatusBar() {
        self.setStatusBarBackgroundColor(.black)
    }
    //MARK: - Methods
    
    func setStatusBarBackgroundColor(_ bgColor: UIColor) {
        
        if #available(iOS 13.0, *) {
            guard let statusBarFrame = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame else { return }
            
            let statusBar = UIView(frame: statusBarFrame)
            statusBar.backgroundColor = bgColor
            
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
            guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
            
            statusBar.backgroundColor = bgColor
        }
    }
    
    
    
    
    @objc func goToPreviousPage() {
        self.navigationController?.popViewController(animated: false)
    }
    
    func showSomethingWentWrongAlert() {
        showAlertWithoutAction("")
    }
    
    func showAlertWithoutAction(_ message: String) {
        
    }
    
    
    
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension UIViewController {
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        }
        else {
            return false
        }
    }
    
}
