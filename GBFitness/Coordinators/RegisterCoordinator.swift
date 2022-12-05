//
//  RegisterCoordinator.swift
//  GBFitness
//
//  Created by Максим Лосев on 04.12.2022.
//

import UIKit

class RegisterCoordinator: BaseCoordinator {
    
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showRegisterModule()
    }
    
    private func showRegisterModule() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else {  return }
        controller.onMap = { [weak self] in self?.showMapModule() }
        let rootController = UINavigationController(rootViewController:
                                                        controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
    
    private func showMapModule() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        rootController?.pushViewController(controller, animated: true)
    }
    
}
