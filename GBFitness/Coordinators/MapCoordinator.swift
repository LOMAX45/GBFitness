//
//  MapCoordinator.swift
//  GBFitness
//
//  Created by Максим Лосев on 04.12.2022.
//

import UIKit

class MapCoordinator: BaseCoordinator {
    
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showMapModule()
    }
    
    private func showMapModule() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else {  return }
        controller.onLogin = { [weak self] in self?.onFinishFlow?()
        }
        let rootController = UINavigationController(rootViewController:
                                                        controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
    
}
