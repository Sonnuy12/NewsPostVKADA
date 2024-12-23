//
//  AlertManager.swift
//  NewsPostVKADA
//
//  Created by сонный on 23.12.2024.
//


import UIKit

final class AlertManager {
    static func showAlert(
        on viewController: UIViewController,
        title: String,
        message: String,
        confirmTitle: String = "ОК",
        cancelTitle: String = "Отмена",
        confirmHandler: (() -> Void)? = nil,
        cancelHandler: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            confirmHandler?()
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancelHandler?()
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}