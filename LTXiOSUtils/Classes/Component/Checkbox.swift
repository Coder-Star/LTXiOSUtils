//
//  Checkbox.swift
//  LTXiOSUtils
//  选择框
//  Created by 李天星 on 2019/11/21.
//

import Foundation
import UIKit

public class Checkbox: UIControl {

    /// 选择框内部选中样式
    public enum CheckmarkStyle {
        /// ■
        case square
        /// ●
        case circle
        /// ╳
        case cross
        /// ✓
        case tick
    }

    /// 选择框边框样式
    public enum BorderStyle {
        /// ▢
        case square
        /// ◯
        case circle
    }

    /// 默认选中样式
    public var checkmarkStyle: CheckmarkStyle = .square
    /// 默认边框样式
    public var borderStyle: BorderStyle = .square
    /// 边框宽度
    public var borderLineWidth: CGFloat = 2
    /// 选中样式尺寸
    public var checkmarkSize: CGFloat = 0.5
    /// 未选中边框颜色
    public var uncheckedBorderColor: UIColor!
    /// 选中边框颜色
    public var checkedBorderColor: UIColor!
    /// 内部选中样式颜色
    public var checkmarkColor: UIColor!
    /// 选中时内部空白处颜色
    public var checkboxFillColor: UIColor = .clear
    /// 未选中时内部空白颜色
    public var uncheckboxFillColor: UIColor = .clear
    /// 圆角度数，只适用于当BorderStyle = square
    public var borderCornerRadius: CGFloat = 0.0
    /// 增大外部热区尺寸
    public var increasedTouchRadius: CGFloat = 5
    /// 选中状态改变闭包
    public var valueChanged: ((_ isChecked: Bool) -> Void)?
    /// 是否选中
    public var isChecked: Bool = false {
        didSet { setNeedsDisplay() }
    }
    /// 选中时是否有触感反馈效果
    public var useHapticFeedback: Bool = true

    private var feedbackGenerator: UIImpactFeedbackGenerator?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDefaults()
    }

    private func setupDefaults() {
        backgroundColor = UIColor.init(white: 1, alpha: 0)
        uncheckedBorderColor = tintColor
        checkedBorderColor = tintColor
        checkmarkColor = tintColor

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(recognizer:)))
        addGestureRecognizer(tapGesture)

        if useHapticFeedback {
            feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            feedbackGenerator?.prepare()
        }
    }

    override public func draw(_ rect: CGRect) {
        drawBorder(shape: borderStyle, in: rect)
        if isChecked {
            drawCheckmark(style: checkmarkStyle, in: rect)
        }
    }

    // MARK: - Borders
    private func drawBorder(shape: BorderStyle, in rect: CGRect) {
        let adjustedRect = CGRect(x: borderLineWidth / 2,
                                  y: borderLineWidth / 2,
                                  width: rect.width - borderLineWidth,
                                  height: rect.height - borderLineWidth)

        switch shape {
        case .circle:
            circleBorder(rect: adjustedRect)
        case .square:
            squareBorder(rect: adjustedRect)
        }
    }

    private func squareBorder(rect: CGRect) {
        let rectanglePath = UIBezierPath(roundedRect: rect, cornerRadius: borderCornerRadius)

        if isChecked {
            checkedBorderColor.setStroke()
        } else {
            uncheckedBorderColor.setStroke()
        }

        rectanglePath.lineWidth = borderLineWidth
        rectanglePath.stroke()
        if isChecked {
            checkboxFillColor.setFill()
        } else {
            uncheckboxFillColor.setFill()
        }
        rectanglePath.fill()
    }

    private func circleBorder(rect: CGRect) {
        let ovalPath = UIBezierPath(ovalIn: rect)

        if isChecked {
            checkedBorderColor.setStroke()
        } else {
            uncheckedBorderColor.setStroke()
        }

        ovalPath.lineWidth = borderLineWidth / 2
        ovalPath.stroke()
        if isChecked {
            checkboxFillColor.setFill()
        } else {
            uncheckboxFillColor.setFill()
        }
        ovalPath.fill()
    }

    // MARK: - Checkmarks
    private func drawCheckmark(style: CheckmarkStyle, in rect: CGRect) {
        let adjustedRect = checkmarkRect(in: rect)
        switch checkmarkStyle {
        case .square:
            squareCheckmark(rect: adjustedRect)
        case .circle:
            circleCheckmark(rect: adjustedRect)
        case .cross:
            crossCheckmark(rect: adjustedRect)
        case .tick:
            tickCheckmark(rect: adjustedRect)
        }
    }

    private func circleCheckmark(rect: CGRect) {
        let ovalPath = UIBezierPath(ovalIn: rect)
        checkmarkColor.setFill()
        ovalPath.fill()
    }

    private func squareCheckmark(rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        checkmarkColor.setFill()
        path.fill()
    }

    private func crossCheckmark(rect: CGRect) {
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: rect.minX + 0.06250 * rect.width, y: rect.minY + 0.06452 * rect.height))
        bezier4Path.addLine(to: CGPoint(x: rect.minX + 0.93750 * rect.width, y: rect.minY + 0.93548 * rect.height))
        bezier4Path.move(to: CGPoint(x: rect.minX + 0.93750 * rect.width, y: rect.minY + 0.06452 * rect.height))
        bezier4Path.addLine(to: CGPoint(x: rect.minX + 0.06250 * rect.width, y: rect.minY + 0.93548 * rect.height))
        checkmarkColor.setStroke()
        bezier4Path.lineWidth = checkmarkSize * 2
        bezier4Path.stroke()
    }

    private func tickCheckmark(rect: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: rect.minX + 0.04688 * rect.width, y: rect.minY + 0.63548 * rect.height))
        bezierPath.addLine(to: CGPoint(x: rect.minX + 0.34896 * rect.width, y: rect.minY + 0.95161 * rect.height))
        bezierPath.addLine(to: CGPoint(x: rect.minX + 0.95312 * rect.width, y: rect.minY + 0.04839 * rect.height))
        checkmarkColor.setStroke()
        bezierPath.lineWidth = checkmarkSize * 2
        bezierPath.stroke()
    }

    // MARK: - Size Calculations
    private func checkmarkRect(in rect: CGRect) -> CGRect {
        let width = rect.maxX * checkmarkSize
        let height = rect.maxY * checkmarkSize
        let adjustedRect = CGRect(x: (rect.maxX - width) / 2,
                                  y: (rect.maxY - height) / 2,
                                  width: width,
                                  height: height)
        return adjustedRect
    }

    // MARK: - Touch
    @objc
    private func handleTapGesture(recognizer: UITapGestureRecognizer) {
        isChecked = !isChecked
        valueChanged?(isChecked)
        sendActions(for: .valueChanged)

        if useHapticFeedback {
            // Trigger impact feedback.
            feedbackGenerator?.impactOccurred()

            // Keep the generator in a prepared state.
            feedbackGenerator?.prepare()
        }
    }

    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let relativeFrame = self.bounds
        let hitTestEdgeInsets = UIEdgeInsets(top: -increasedTouchRadius, left: -increasedTouchRadius, bottom: -increasedTouchRadius, right: -increasedTouchRadius)
        let hitFrame = relativeFrame.inset(by: hitTestEdgeInsets)
        return hitFrame.contains(point)
    }

}
