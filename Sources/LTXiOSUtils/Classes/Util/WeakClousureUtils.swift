//
//  WeakClousureUtils.swift
//  LTXiOSUtils
//  Clousure避免未使用 [weak self]
//  Created by CoderStar on 2021/12/16.
//

import Foundation

/**
 // 使用方式
 // 观察
 class TextInputView: UIView {
     let onConfirmInput = WeakClousure<String?, String>()

     func confirmButtonPressed(_ sender: Any) {
         let result = onConfirmInput.call(inputTextField.text)

         let result = onConfirmInput(inputTextField.text))
     }
 }

 // 触发
 // (self, text)这里地方的self一定不能使用 _ 代替，会导致循环引用
 inputView.onConfirmInput.delegate(on: self) { (self, text) in
     self.textLabel.text = text
 }
 */

public class WeakClousure<Input, Output> {
    private var block: ((Input) -> Output?)?

    public func delegate<T: AnyObject>(on target: T, block: ((T, Input) -> Output)?) {
        self.block = { [weak target] input in
            guard let target = target else { return nil }
            return block?(target, input)
        }
    }

    // swift 5.2新特性
    public func callAsFunction(_ input: Input) -> Output? {
        return call(input)
    }

    public func call(_ input: Input) -> Output? {
        return block?(input)
    }
}
