//
//  AuthCoordinator.swift
//  GBFitness
//
//  Created by Максим Лосев on 04.12.2022.
//

import UIKit

class AuthCoordinator: BaseCoordinator {
    
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showLoginModule()
    }
    
    private func showLoginModule() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {  return }
        controller.onRegister = { [weak self] in self?.showRegisterModule() }
        controller.onMap = { [weak self] in self?.onFinishFlow?() }
        let rootController = UINavigationController(rootViewController:
                                                        controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
    
    private func showRegisterModule() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else { return }
        rootController?.pushViewController(controller, animated: true)
    }
    
}
