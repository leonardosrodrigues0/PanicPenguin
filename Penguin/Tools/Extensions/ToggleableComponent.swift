//
//  ToggleableComponent.swift
//  Penguin
//
//  Created by Erick Manaroulas Felipe on 04/02/22.
//

import GameplayKit

protocol ToggleableComponent: GKComponent {
    func disable()
    func enable()
    func onDisable()
    func onEnable()
}

extension ToggleableComponent {
    func onDisable() {}
    func onEnable() {}
}

extension GKEntity {
    func disable() {
        components.forEach { ($0 as? ToggleableComponent)?.disable() }
    }

    func enable() {
        components.forEach { ($0 as? ToggleableComponent)?.enable() }
    }
}
