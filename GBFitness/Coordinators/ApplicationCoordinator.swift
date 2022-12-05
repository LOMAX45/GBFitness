//
//  ApplicationCoordinator.swift
//  GBFitness
//
//  Created by Максим Лосев on 04.12.2022.
//

import Foundation

final class ApplicationCoordinator: BaseCoordinator {
    
    override func start() {
        if UserDefaults.standard.bool(forKey: "isLogin") {
            toMap()
        } else {
            toAuth()
        }
    }
    
    private func toMap() {
        // Создаём координатор главного сценария
        let coordinator = MapCoordinator()
        
        // Устанавливаем ему поведение на завершение
        coordinator.onFinishFlow = { [weak self, weak coordinator] in
            // Так как подсценарий завершился, держать его в памяти больше не нужно
            self?.removeDependency(coordinator)
            // Заново запустим главный координатор, чтобы выбрать следующий сценарий
            self?.start()
        }
        
        // Сохраним ссылку на дочерний координатор, чтобы он не выгружался из памяти
        addDependency(coordinator)
        // Запустим сценарий дочернего координатора
        coordinator.start()
    }
    
    private func toAuth() {
        // Создаём координатор сценария авторизации
        let coordinator = AuthCoordinator()
        
        // Устанавливаем ему поведение на завершение
        coordinator.onFinishFlow = { [weak self, weak coordinator] in
            // Так как подсценарий завершился, держать его в памяти больше не нужно
            self?.removeDependency(coordinator)
            // Заново запустим главный координатор, чтобы выбрать выбрать следующий // сценарий
            self?.start()
        }
        
        // Сохраним ссылку на дочерний координатор, чтобы он не выгружался из памяти
        addDependency(coordinator)
        // Запустим сценарий дочернего координатора
        coordinator.start()
    }
    
    func registrationDone() {
        // Создаём координатор сценария авторизации
        let coordinator = RegisterCoordinator()
        
        // Устанавливаем ему поведение на завершение
        coordinator.onFinishFlow = { [weak self, weak coordinator] in
            // Так как подсценарий завершился, держать его в памяти больше не нужно
            self?.removeDependency(coordinator)
            // Заново запустим главный координатор, чтобы выбрать выбрать следующий // сценарий
//            self?.start()
        }
        
        // Сохраним ссылку на дочерний координатор, чтобы он не выгружался из памяти
        addDependency(coordinator)
        // Запустим сценарий дочернего координатора
        coordinator.start()
    }
    
}
