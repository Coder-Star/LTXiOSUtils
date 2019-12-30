//
//  DurationDatePickView.swift
//  LTXiOSUtils
//  起止时间选择弹出框
//  Created by 李天星 on 2019/11/21.
//

import Foundation
import UIKit

/// 选择器样式
public enum DurationDatePickViewDateType: String {
    /// 年月日时分 2019-01-01 12:00
    case YMDHM = "yyyy-MM-dd HH:mm"
    /// 年月日 2019-01-01
    case YMD = "yyyy-MM-dd"
}

/// 起止时间弹出框
open class DurationDatePickView: UIView {

    public typealias SureBlock = (_ startDate: String, _ endDate: String) -> Void
    public typealias CancelBlock = () -> Void

    /// 选择日期是否可大于现在，默认true
    public var canGreatNow = true
    /// 选择日期是否可小于现在，默认true
    public var canLessNow = true
    /// 确定闭包
    public var sureBlock: SureBlock?
    /// 取消闭包
    public var cancelBlock: CancelBlock?

    /// 日期类型
    private var dateType: DurationDatePickViewDateType = .YMD
    /// 最小时间
    private let minDate: Date = Date.init(timeIntervalSince1970: 0)
    /// 最大时间
    private let maxDate: Date = Date.init(timeIntervalSinceNow: TimeInterval(60*60*24*365*20))
    /// 弹窗距离左右边距
    private let leftAndRightMargin: CGFloat = 35
    /// 弹窗高度
    private let popupViewHeight: CGFloat = 220
    /// 时间选择器的高度
    private let datePickerHeight: CGFloat = 200
    /// 时间选择器
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.calendar = Calendar.current
        datePicker.timeZone = TimeZone.current
        if let language = Locale.preferredLanguages.first {
            datePicker.locale = Locale(identifier: language)
        }
        datePicker.backgroundColor = UIColor.white.adapt()
        datePicker.alpha = 0
        return datePicker
    }()

    /// 屏幕高度
    private let screenHeight = UIScreen.main.bounds.height
    /// 屏幕宽度
    private let screenWith = UIScreen.main.bounds.width

    // MARK: 内部控件，懒加载
    public lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.frame = CGRect.init(x: 0, y: 0, width: screenWith, height: screenHeight)
        coverView.backgroundColor = UIColor.black.adapt()
        coverView.alpha = 0
        return coverView
    }()

    public lazy var popupView: UIView = {
        let popupView = UIView()
        let width = screenWith - (leftAndRightMargin * 2)
        let topMargin: CGFloat = (screenHeight - popupViewHeight - datePickerHeight) / 2
        popupView.frame = CGRect.init(x: leftAndRightMargin, y: topMargin, width: width, height: popupViewHeight)
        popupView.backgroundColor = UIColor.white.adapt()
        popupView.layer.masksToBounds = true
        popupView.layer.cornerRadius = 10
        popupView.alpha = 0
        return popupView
    }()

    public lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.frame = CGRect.init(x: 0, y: 0, width: popupView.frame.width, height: 50)
        titleLabel.text = "DurationDatePickView.topTitle".localizedOfLTXiOSUtils()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.black.adapt()
        titleLabel.textAlignment = .center
        return titleLabel
    }()

    public lazy var startBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor(hexString: "#333333").adapt(), for: .normal)
        btn.setTitleColor(UIColor(hexString: "#0F9CFE"), for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.titleLabel?.textAlignment = .right
        btn.addTarget(self, action: #selector(startBtnAction(btn:)), for: .touchUpInside)

        let titleString = self.datePicker.date.formatDate(formatStr: dateType.rawValue)
        btn.setTitle(titleString, for: .normal)
        if dateType == .YMDHM {
            let title = DurationDatePickView.appendTime(dateAndTime: titleString)
            btn.setTitle(title, for: .normal)
        }
        btn.isSelected = true
        return btn
    }()

    public lazy var endBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor(hexString: "#333333").adapt(), for: .normal)
        btn.setTitleColor(UIColor(hexString: "#0F9CFE"), for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.titleLabel?.textAlignment = .left
        btn.addTarget(self, action: #selector(endBtnAction(btn:)), for: .touchUpInside)
        return btn
    }()

    public lazy var cancelBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 0, y: self.popupView.frame.height - 49, width: (self.popupView.frame.width - 1) / 2.0, height: 49)
        btn.setTitle("cancel".localizedOfLTXiOSUtils(), for: .normal)
        btn.setTitleColor(UIColor(hexString: "#0F9CFE"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        return btn
    }()

    public lazy var confirmBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        let x: CGFloat = self.popupView.frame.width - self.cancelBtn.frame.width - 1
        let y: CGFloat = self.popupView.frame.height - 49
        let w: CGFloat = (self.popupView.frame.width - 1) / 2.0
        let h: CGFloat = 49
        btn.frame = CGRect.init(x: x, y: y, width: w, height: h)
        btn.setTitle("sure".localizedOfLTXiOSUtils(), for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        UIApplication.shared.keyWindow?.addSubview(self)
        self.frame = self.superview?.bounds ?? UIScreen.main.bounds
        self.addSubview(coverView)
        self.addSubview(datePicker)
        self.addSubview(popupView)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 暴露出去的方法，供外部调用
public extension DurationDatePickView {

    /// 展示起止时间弹出框
    /// - Parameters:
    ///   - startDate: 开始时间
    ///   - endDate: 结束时间
    ///   - canGreatNow: 是否可大于当前时间，默认为true
    ///   - canLessNow: 是否可以小于当前时间，默认为true
    ///   - dateType: 时间类型
    ///   - sureBlock: 确定闭包
    ///   - cancelBlock: 取消闭包
    class func showPopupView(startDate: Date,
                             endDate: Date,
                             canGreatNow: Bool = true,
                             canLessNow: Bool = true,
                             dateType: DurationDatePickViewDateType = .YMD,
                             sureBlock: @escaping SureBlock,
                             cancelBlock: CancelBlock? = nil) {
        let popupView = getPopupView(startDate: startDate, endDate: endDate, canGreatNow: canGreatNow, canLessNow: canLessNow, dateType: dateType)
        popupView.sureBlock = sureBlock
        popupView.cancelBlock = cancelBlock
        popupView.show()
    }

    /// 展示起止时间弹出框
    /// - Parameters:
    ///   - startDate: 开始时间
    ///   - endDate: 结束时间
    ///   - canGreatNow: 是否可大于当前时间，默认为true
    ///   - canLessNow: 是否可以小于当前时间，默认为true
    ///   - dateType: 时间类型
    class func getPopupView(startDate: Date,
                            endDate: Date,
                            canGreatNow: Bool = true,
                            canLessNow: Bool = true,
                            dateType: DurationDatePickViewDateType = .YMD) -> DurationDatePickView {

        let window = UIApplication.shared.keyWindow
        window?.endEditing(true)
        let popupView = DurationDatePickView.init(frame: UIScreen.main.bounds)

        popupView.datePicker.setDate(startDate, animated: false)

        popupView.canGreatNow = canGreatNow
        popupView.canLessNow = canLessNow
        popupView.dateType = dateType

        if dateType == .YMDHM {
            let startTitle = appendTime(dateAndTime: startDate.formatDate(formatStr: dateType.rawValue))
            popupView.startBtn.setTitle(startTitle, for: .normal)

            let endTitle = appendTime(dateAndTime: endDate.formatDate(formatStr: dateType.rawValue))
            popupView.endBtn.setTitle(endTitle, for: .normal)
        } else {
            popupView.startBtn.setTitle(startDate.formatDate(formatStr: dateType.rawValue), for: .normal)
            popupView.endBtn.setTitle(endDate.formatDate(formatStr: dateType.rawValue), for: .normal)
        }

        popupView.setDatePickerStyle()
        popupView.setPopupView()
        popupView.startBtnAction(btn: popupView.startBtn)
        return popupView
    }

    /// 弹出框显示
    func show() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.coverView.alpha = 0.5
            self?.popupView.alpha = 1
            self?.datePicker.alpha = 1
            }, completion: { _ in

        })
    }

    /// 弹出框消失
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.coverView.alpha = 0
            self?.popupView.alpha = 0
            self?.datePicker.alpha = 0
            }, completion: { _ in
                self.removeFromSuperview()
        })
    }

}

// MARK: - 事件处理
extension DurationDatePickView {

    @objc func startBtnAction(btn: UIButton) {
        btn.isSelected = true
        endBtn.isSelected = false
        if canLessNow {
            datePicker.minimumDate = minDate
        } else {
            datePicker.minimumDate = Date.init(timeIntervalSinceNow: 0)
        }
        if canGreatNow {
            datePicker.maximumDate = maxDate
        } else {
            datePicker.maximumDate = Date.init(timeIntervalSinceNow: 0)
        }
        rollCurrentDate(btn: btn)
    }

    @objc func endBtnAction(btn: UIButton) {
        btn.isSelected = true
        startBtn.isSelected = false
        if dateType == .YMD, let date = startBtn.currentTitle?.toDate(dateTypeStr: dateType.rawValue) {
            datePicker.minimumDate = date
        } else if dateType  == .YMDHM, let date = startBtn.currentTitle?.replaceNewlineWithWhitespace().toDate(dateType: .YMDHM) {
            datePicker.minimumDate = date
        }
        if canGreatNow {
            datePicker.maximumDate = maxDate
        } else {
            datePicker.maximumDate = Date.init(timeIntervalSinceNow: 0)
        }
        rollCurrentDate(btn: btn)
    }

    @objc func cancelBtnAction() {
        if let block = cancelBlock {
            block()
        }
        dismiss()
    }

    @objc func confirmBtnAction() {
        if let block = sureBlock {
            let startDate = startBtn.currentTitle?.replaceNewlineWithWhitespace() ?? ""
            let endDate = endBtn.currentTitle?.replaceNewlineWithWhitespace() ?? ""
            block(startDate, endDate)
        }
        dismiss()
    }

    @objc func datePicekerValueChanged(picker: UIDatePicker) {
        let date = picker.date
        let titleString = date.formatDate(formatStr: dateType.rawValue)

        if startBtn.isSelected {
            if dateType == .YMD {
                startBtn.setTitle(titleString, for: .normal)
                if titleString > endBtn.currentTitle ?? ""{
                    if let tempDate = titleString.toDate(dateTypeStr: dateType.rawValue)?.getDateByDays(days: 1).formatDate(format: .YMD) {
                        endBtn.setTitle(tempDate, for: .normal)
                    }
                }
            } else if dateType == .YMDHM {
                let title = DurationDatePickView.appendTime(dateAndTime: titleString)
                startBtn.setTitle(title, for: .normal)
                if titleString > endBtn.currentTitle?.replaceNewlineWithWhitespace() ?? ""{
                    if let tempDate = titleString.toDate(dateTypeStr: dateType.rawValue)?.getDateByDays(days: 1).formatDate(format: .YMDHM) {
                        let tempString = DurationDatePickView.appendTime(dateAndTime: tempDate)
                        endBtn.setTitle(tempString, for: .normal)
                    }
                }
            }
        } else {
            endBtn.setTitle(titleString, for: .normal)
            if dateType == .YMDHM {
                let title = DurationDatePickView.appendTime(dateAndTime: titleString)
                endBtn.setTitle(title, for: .normal)
            }
        }
    }
}

// MARK: - 私有方法
extension DurationDatePickView {

    private func rollCurrentDate(btn: UIButton) {
        if let dateStr = btn.currentTitle?.replaceNewlineWithWhitespace(), let date = dateStr.toDate(dateTypeStr: dateType.rawValue) {
            datePicker.setDate(date, animated: true)
        }
    }

    /// 设置日期选择器相关属性
    private func setDatePickerStyle() {
        datePicker.frame = CGRect.init(x: 0, y: screenHeight - datePickerHeight, width: screenWith, height: datePickerHeight)
        if dateType == .YMDHM {
            datePicker.datePickerMode = .dateAndTime
        } else if dateType == .YMD {
            datePicker.datePickerMode = .date
        }

        if canLessNow {
            datePicker.minimumDate = minDate
        } else {
            datePicker.minimumDate = Date.init(timeIntervalSinceNow: 0)
        }

        if canGreatNow {
            datePicker.maximumDate = maxDate
        } else {
            datePicker.maximumDate = Date.init(timeIntervalSinceNow: 0)
        }

        datePicker.addTarget(self, action: #selector(datePicekerValueChanged(picker:)), for: .valueChanged)
    }

    /// 设置popupView上的子控件
    private func setPopupView() {

        //第一部分
        popupView.addSubview(titleLabel)
        let topLineView = UIView()
        topLineView.frame = CGRect.init(x: 0, y: 50, width: popupView.frame.width, height: 1)
        topLineView.backgroundColor = UIColor(hexString: "#F2F2F2")
        popupView.addSubview(topLineView)

        //第二部分
        popupView.addSubview(self.startBtn)
        self.startBtn.frame = CGRect.init(x: 20, y: topLineView.frame.maxY + 20, width: (popupView.frame.width - 60) / 2.0, height: popupView.frame.height - 100 - 40)
        self.startBtn.titleLabel?.lineBreakMode = .byCharWrapping
        self.startBtn.titleLabel?.numberOfLines = 0
        self.startBtn.titleLabel?.textAlignment = .center

        let tempLabel = UILabel()
        tempLabel.frame = CGRect.init(x: self.startBtn.frame.maxX, y: self.startBtn.frame.minY, width: 20, height: self.startBtn.frame.height)
        tempLabel.textAlignment = .center
        tempLabel.text = "DurationDatePickView.to".localizedOfLTXiOSUtils()
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        tempLabel.textColor = UIColor(hexString: "#999999")
        popupView.addSubview(tempLabel)

        popupView.addSubview(self.endBtn)
        self.endBtn.frame = CGRect.init(x: tempLabel.frame.maxX, y: self.startBtn.frame.minY, width: self.startBtn.frame.width, height: self.startBtn.frame.height)
        self.endBtn.titleLabel?.lineBreakMode = .byCharWrapping
        self.endBtn.titleLabel?.numberOfLines = 0
        self.endBtn.titleLabel?.textAlignment = .center

        let bottomLineView = UIView()
        bottomLineView.frame = CGRect.init(x: 0, y: popupViewHeight - 50, width: popupView.frame.width, height: 1)
        bottomLineView.backgroundColor = UIColor(hexString: "#F2F2F2")
        popupView.addSubview(bottomLineView)

        //第三部分
        popupView.addSubview(self.cancelBtn)

        let verticalLineView: UIView = UIView()
        verticalLineView.frame = CGRect.init(x: self.cancelBtn.frame.width, y: self.cancelBtn.frame.minY, width: 1, height: self.cancelBtn.frame.height)
        verticalLineView.backgroundColor = UIColor(hexString: "#F2F2F2")
        popupView.addSubview(verticalLineView)

        popupView.addSubview(self.confirmBtn)
    }
}

// MARK: - 方法
extension DurationDatePickView {

    private static func appendTime(dateAndTime: String) -> String {
        let date = dateAndTime.getDateStr(dateType: .YMD)
        let time = dateAndTime.getDateStr(dateType: .HM)
        return date + "\n" + time
    }
}

extension String {
    /// 使用空格替换字符串中的换行
    func replaceNewlineWithWhitespace() -> String {
        return self.replacingOccurrences(of: "\n", with: " ")
    }
}
