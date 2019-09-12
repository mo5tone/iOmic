//
//  UIColor.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

protocol ColorSystem {
    var none: UIColor { get }
    var clear: UIColor { get }
    var tint: UIColor { get }
    var barTint: UIColor { get }
    var background: UIColor { get }
    var darkText: UIColor { get }
    var lightText: UIColor { get }
    var border: UIColor { get }
    var shadow: UIColor { get }
    var animation: UIColor { get }
    var selected: UIColor { get }
    var disabled: UIColor { get }
    var error: UIColor { get }
    var favorite: UIColor { get }
}

extension ColorSystem {
    var none: UIColor { return .black }
    var clear: UIColor { return .clear }
}

extension UIColor {
    struct Flat {}
    static var flat: Flat { return .init() }
}

// MARK: - flatuicolors https://flatuicolors.com/palette/cn

private extension UIColor.Flat {
    var goldenSand: UIColor { return .init(hex: "eccc68") }
    var coral: UIColor { return .init(hex: "ff7f50") }
    var wildWatermelon: UIColor { return .init(hex: "ff6b81") }
    var peace: UIColor { return .init(hex: "a4b0be") }
    var grisaille: UIColor { return .init(hex: "57606f") }
    var orange: UIColor { return .init(hex: "ffa502") }
    var bruschettaTomato: UIColor { return .init(hex: "ff6348") }
    var watermelon: UIColor { return .init(hex: "ff4757") }
    var bayWharf: UIColor { return .init(hex: "747d8c") }
    var prestigeBlue: UIColor { return .init(hex: "2f3542") }
    var limeSoap: UIColor { return .init(hex: "7bed9f") }
    var frenchSkyBlue: UIColor { return .init(hex: "70a1ff") }
    var saturatedSky: UIColor { return .init(hex: "5352ed") }
    var white: UIColor { return .init(hex: "ffffff") }
    var cityLights: UIColor { return .init(hex: "dfe4ea") }
    var ufoGreen: UIColor { return .init(hex: "2ed573") }
    var clearChill: UIColor { return .init(hex: "1e90ff") }
    var brightGreek: UIColor { return .init(hex: "3742fa") }
    var antiFlashWhite: UIColor { return .init(hex: "f1f2f6") }
    var twinkleBlue: UIColor { return .init(hex: "ced6e0") }
}

// MARK: - Flat ColorSystem

extension UIColor.Flat: ColorSystem {
    var tint: UIColor { return clearChill }
    var barTint: UIColor { return white }
    var background: UIColor { return antiFlashWhite }
    var darkText: UIColor { return prestigeBlue }
    var lightText: UIColor { return cityLights }
    var border: UIColor { return grisaille }
    var shadow: UIColor { return bayWharf }
    var animation: UIColor { return peace }
    var selected: UIColor { return grisaille }
    var disabled: UIColor { return peace }
    var error: UIColor { return watermelon }
    var favorite: UIColor { return wildWatermelon }
}
