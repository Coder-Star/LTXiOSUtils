//
//  DurationDatePickView.swift
//  LTXiOSUtils
//  起止时间选择弹出框
//  Created by 李天星 on 2019/11/21.
//

import Foundation
import UIKit

private let kGaoJianLongScreenWidth: CGFloat = UIScreen.main.bounds.size.width
private let kGaoJianLongScreenHeight: CGFloat = UIScreen.main.bounds.size.height

//弹窗距离左右边距
private let kGaoJianLongSpaceLeftOrRight: CGFloat = 35
//弹窗距离上边距
private let kGaoJianLongSpaceTop: CGFloat = 114
//弹窗宽度
private let kGaoJianLongPopupViewWidth: CGFloat = kGaoJianLongScreenWidth - (kGaoJianLongSpaceLeftOrRight * 2)
//弹窗高度
private let kGaoJianLongPopupViewHeight: CGFloat = 220
//时间选择器的高度
private let kGaoJianLongDatePickerHeight: CGFloat = 200

/// 起止时间弹出框代理
@objc public protocol DurationDatePickViewDelegate {
    /// 确定
    /// - Parameters:
    ///   - startDate: 开始时间
    ///   - endDate: 结束时间
    @objc optional func sure(startDate: String, endDate: String)
    /// 结束
    @objc optional func cancel()
}

/// 选择器样式
public enum DurationDatePickViewDateType: String {
    /// 年月日时分 2019-01-01 12:00
    case YMDHM = "yyyy-MM-dd HH:mm"
    /// 年月日 2019-01-01
    case YMD = "yyyy-MM-dd"
}

open class DurationDatePickView: UIView {
    public var titleLabel = UILabel() //标题Label，修改标题名称

    public var isDateCanGreatNow = false //选择日期是否可大于现在
    public var isDateCanLessNow = true // 选择日期是否可小于现在

    private var dateType: DurationDatePickViewDateType = .YMD

    private var startDateDefaultYMDHM = Date.getCurrentTime()
    private var endDateDefaultYMDHM = Date.getCurrentTime()

    private var startDateDefault = Date.getCurrentDate()
    private var endDateDefault = Date.getCurrentDate()

    let minDate: Date = Date.init(timeIntervalSince1970: 60 * 60)
    let nowDate: Date = Date.init(timeIntervalSinceNow: 60 * 60)
    let maxDate: Date = Date.init(timeIntervalSinceNow: TimeInterval(60*60*24*365*5)) // 默认最大时间

    // 代理属性
    weak var delegate: DurationDatePickViewDelegate?
    fileprivate var datePicker: UIDatePicker = UIDatePicker()

    // MARK: 属性
    fileprivate lazy var coverView: UIView = {
        let v = UIView()
        v.frame = CGRect.init(x: 0, y: 0, width: kGaoJianLongScreenWidth, height: kGaoJianLongScreenHeight)
        v.backgroundColor = UIColor.black
        v.alpha = 0
        return v
    }()

    fileprivate lazy var popupView: UIView = {
        let v = UIView()
        v.frame = CGRect.init(x: kGaoJianLongSpaceLeftOrRight, y: kGaoJianLongSpaceTop, width: kGaoJianLongPopupViewWidth, height: kGaoJianLongPopupViewHeight)
        v.backgroundColor = UIColor.white
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 10
        v.alpha = 0
        return v
    }()

    fileprivate lazy var startBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        btn.setTitleColor(UIColor(hexString: "#0F9CFE"), for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.titleLabel?.textAlignment = .right
        btn.addTarget(self, action: #selector(startBtnAction(btn:)), for: .touchUpInside)

        let date = self.datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateType.rawValue
        let titleString = dateFormatter.string(from: date)
        btn.setTitle(titleString, for: .normal)
        if dateType == .YMDHM {
            let title = DurationDatePickView.appendTime(dateAndTime: titleString)
            btn.setTitle(title, for: .normal)
        }
        btn.isSelected = true
        return btn
    }()

    fileprivate lazy var endBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        btn.setTitleColor(UIColor(hexString: "#0F9CFE"), for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.titleLabel?.textAlignment = .left
        btn.addTarget(self, action: #selector(endBtnAction(btn:)), for: .touchUpInside)
        btn.setTitle(endDateDefault, for: .normal)
        if dateType == .YMDHM {
            let title = DurationDatePickView.appendTime(dateAndTime: endDateDefault)
            btn.setTitle(title, for: .normal)
        }
        return btn
    }()

    fileprivate lazy var cancelBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 0, y: self.popupView.frame.height - 49, width: (self.popupView.frame.width - 1) / 2.0, height: 49)
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor(hexString: "#0F9CFE"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        return btn
    }()

    fileprivate lazy var confirmBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        let x: CGFloat = self.popupView.frame.width - self.cancelBtn.frame.width - 1
        let y: CGFloat = self.popupView.frame.height - 49
        let w: CGFloat = (self.popupView.frame.width - 1) / 2.0
        let h: CGFloat = 49
        btn.frame = CGRect.init(x: x, y: y, width: w, height: h)
        btn.setTitle("确定", for: .normal)
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

    public class func shareTimePopupView() -> DurationDatePickView {
        return DurationDatePickView.init(frame: UIScreen.main.bounds)
    }

}

public extension DurationDatePickView {
    class func getPopupView(delegate: DurationDatePickViewDelegate,
                           startDate: Date,
                           endDate: Date,
                           isDateCanGreatNow: Bool = false,
                           isDateCanLessNow: Bool = true,
                           dateType: DurationDatePickViewDateType = .YMD) -> DurationDatePickView {

        let window = UIApplication.shared.keyWindow
        window?.endEditing(true)
        let popupView = DurationDatePickView.shareTimePopupView()
        popupView.delegate = delegate

        popupView.datePicker.setDate(startDate, animated: false)
        popupView.startBtn.setTitle(startDate.formatDate(formatStr: dateType.rawValue), for: .normal)
        popupView.endBtn.setTitle(endDate.formatDate(formatStr: dateType.rawValue), for: .normal)

        if dateType == .YMDHM {
            let startTitle = appendTime(dateAndTime: startDate.formatDate(formatStr: dateType.rawValue))
            popupView.startBtn.setTitle(startTitle, for: .normal)

            let endTitle = appendTime(dateAndTime: endDate.formatDate(formatStr: dateType.rawValue))
            popupView.endBtn.setTitle(endTitle, for: .normal)
        }

        popupView.isDateCanGreatNow = isDateCanGreatNow
        popupView.isDateCanLessNow = isDateCanLessNow
        popupView.dateType = dateType

        if dateType == .YMDHM {
            popupView.startDateDefault = popupView.startDateDefaultYMDHM
            popupView.endDateDefault = popupView.endDateDefaultYMDHM
        }
        popupView.setDatePickerStyle()
        popupView.setPopupView()
        popupView.startBtnAction(btn: popupView.startBtn)
        return popupView
    }


    class func showPopupView(delegate: DurationDatePickViewDelegate,
                            startDate: Date,
                            endDate: Date,
                            isDateCanGreatNow: Bool = false,
                            isDateCanLessNow: Bool = true,
                            dateType: DurationDatePickViewDateType = .YMD) {
       let popupView = getPopupView(delegate: delegate, startDate: startDate, endDate: endDate, isDateCanGreatNow: isDateCanGreatNow, isDateCanLessNow: isDateCanLessNow, dateType: dateType)
        popupView.show()
    }

    func show() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.coverView.alpha = 0.5
            self?.popupView.alpha = 1
            self?.datePicker.alpha = 1
            }, completion: { _ in

        })
    }

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

extension DurationDatePickView {

    // MARK: 自定义
    @objc func startBtnAction(btn: UIButton) {
        btn.isSelected = true
        endBtn.isSelected = false
        if isDateCanLessNow {
            datePicker.minimumDate = minDate
        } else {
            datePicker.minimumDate = nowDate
        }
        if isDateCanGreatNow {
            datePicker.maximumDate = maxDate
        } else {
            datePicker.maximumDate = nowDate
        }
        rollCurrentDate(btn: btn)
    }

    @objc func endBtnAction(btn: UIButton) {
        btn.isSelected = true
        startBtn.isSelected = false
        if dateType == .YMD, let date = startBtn.currentTitle?.replacingOccurrences(of: "\n", with: " ").toDate(dateTypeStr: dateType.rawValue) {
            datePicker.minimumDate = date
        } else if dateType  == .YMDHM, let date = startBtn.currentTitle?.replacingOccurrences(of: "\n", with: " ").toDate(dateType: .YMDHM) {
            datePicker.minimumDate = date
        }
        if isDateCanGreatNow {
            datePicker.maximumDate = maxDate
        } else {
            datePicker.maximumDate = nowDate
        }
        rollCurrentDate(btn: btn)
    }

    @objc func cancelBtnAction() {
        if delegate != nil, delegate?.cancel != nil {
            delegate?.cancel!()
        }
        dismiss()
    }

    @objc func confirmBtnAction() {
        if (delegate != nil) && ((delegate?.sure(startDate: endDate:)) != nil) {
            delegate?.sure!(startDate: (startBtn.currentTitle ?? startDateDefault).replacingOccurrences(of: "\n", with: " "), endDate: (endBtn.currentTitle ?? endDateDefault).replacingOccurrences(of: "\n", with: " "))
        }
        dismiss()
    }

    @objc func datePicekerValueChanged(picker: UIDatePicker) {
        let date = picker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateType.rawValue
        let titleString: String = dateFormatter.string(from: date)
        let isStartSelected: String = startBtn.isSelected ? "true" : "false"

        if isStartSelected == "true"{
            if dateType == .YMD {
                startBtn.setTitle(titleString, for: .normal)
                if titleString > endBtn.currentTitle ?? Date().formatDate(format: .YMD) {
                    endBtn.setTitle(titleString, for: .normal)
                }
            } else if dateType == .YMDHM {
                let title = DurationDatePickView.appendTime(dateAndTime: titleString)
                startBtn.setTitle(title, for: .normal)
                if titleString > endBtn.currentTitle ?? Date().formatDate(format: .YMDHM) {
                    let tempDate =  titleString.toDate(dateTypeStr: dateType.rawValue)?.getDateByDays(days: 1).formatDate(format: .YMDHM) ?? ""
                    let tempString = DurationDatePickView.appendTime(dateAndTime: tempDate)
                    endBtn.setTitle(tempString, for: .normal)
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

extension DurationDatePickView {

    fileprivate func rollCurrentDate(btn: UIButton) {
        if let dateStr = btn.currentTitle, let date = dateStr.toDate(dateTypeStr: dateType.rawValue) {
            datePicker.setDate(date, animated: true)
        }
    }

    /// 设置日期选择器相关属性
    fileprivate func setDatePickerStyle() {
        datePicker.alpha = 0
        datePicker.frame = CGRect.init(x: 0, y: kGaoJianLongScreenHeight - kGaoJianLongDatePickerHeight + 20, width: kGaoJianLongScreenWidth, height: kGaoJianLongDatePickerHeight)
        datePicker.backgroundColor = UIColor.white
        datePicker.calendar = Calendar.current
        datePicker.locale = Locale.current
        if dateType == .YMDHM {
            datePicker.datePickerMode = .dateAndTime
        } else if dateType == .YMD {
            datePicker.datePickerMode = .date
        }

        if isDateCanLessNow {
            datePicker.minimumDate = minDate
        } else {
            datePicker.minimumDate = nowDate
        }

        if isDateCanGreatNow {
            datePicker.maximumDate = maxDate
        } else {
            datePicker.maximumDate = nowDate
        }

        datePicker.addTarget(self, action: #selector(datePicekerValueChanged(picker:)), for: .valueChanged)
    }

    /// 设置popupView上的子控件
    fileprivate func setPopupView() {
        //第一部分
        titleLabel.frame = CGRect.init(x: 0, y: 0, width: popupView.frame.width, height: 50)
        titleLabel.text = "请选择起止时间"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
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
        tempLabel.text = "至"
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        tempLabel.textColor = UIColor(hexString: "#999999")
        popupView.addSubview(tempLabel)

        popupView.addSubview(self.endBtn)
        self.endBtn.frame = CGRect.init(x: tempLabel.frame.maxX, y: self.startBtn.frame.minY, width: self.startBtn.frame.width, height: self.startBtn.frame.height)
        self.endBtn.titleLabel?.lineBreakMode = .byCharWrapping
        self.endBtn.titleLabel?.numberOfLines = 0
        self.endBtn.titleLabel?.textAlignment = .center

        let bottomLineView = UIView()
        bottomLineView.frame = CGRect.init(x: 0, y: kGaoJianLongPopupViewHeight - 50, width: popupView.frame.width, height: 1)
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

extension DurationDatePickView {

    static func appendTime(dateAndTime: String) -> String {
        let date = dateAndTime.getDateStr(dateType: .YMD)
        let time = dateAndTime.getDateStr(dateType: .HM)
        return date + "\n" + time
    }
}
