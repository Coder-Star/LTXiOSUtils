//
//  PickerViewManager.swift
//  LTXiOSUtils
//  弹出框控制
//  Created by 李天星 on 2019/11/21.
//

import UIKit

public class PickerViewManager: UIView {

    public typealias BtnAction = () -> Void
    public typealias SingleDoneAction = (_ selectedIndex: Int, _ selectedValue: String) -> Void
    public typealias MultipleDoneAction = (_ selectedIndexs: [Int], _ selectedValues: [String]) -> Void
    public typealias DateDoneAction = (_ selectedDate: Date) -> Void

    public typealias MultipleAssociatedDataType = [[[String: [String]?]]]

    private var pickerView: PickerView!
    // MARK: - 常量
    private let pickerViewHeight: CGFloat = 260.0

    private let screenWidth = UIScreen.main.bounds.size.width
    private let screenHeight = UIScreen.main.bounds.size.height
    private var hideFrame: CGRect {
        return CGRect(x: 0.0, y: screenHeight, width: screenWidth, height: pickerViewHeight)
    }
    private var showFrame: CGRect {
        return CGRect(x: 0.0, y: screenHeight - pickerViewHeight, width: screenWidth, height: pickerViewHeight)
    }

    // MARK: - 初始化
    // 单列
    convenience init(frame: CGRect, toolBarTitle: String, singleColData: [String], defaultSelectedIndex: Int?, clearAction: BtnAction?, doneAction: SingleDoneAction?) {
        self.init(frame: frame)
        pickerView = PickerView.singleColPicker(toolBarTitle, singleColData: singleColData, defaultIndex: defaultSelectedIndex, cancelAction: { [unowned self] in
            clearAction?()
            self.hidePicker()
            }, doneAction: {[unowned self] (selectedIndex, selectedValue) in
                doneAction?(selectedIndex, selectedValue)
                self.hidePicker()
        })
        pickerView.frame = hideFrame
        addSubview(pickerView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        addGestureRecognizer(tap)

    }

    // 多列不关联
    convenience init(frame: CGRect, toolBarTitle: String, multipleColsData: [[String]], defaultSelectedIndexs: [Int]?, clearAction: BtnAction?, doneAction: MultipleDoneAction?) {
        self.init(frame: frame)
        pickerView = PickerView.multipleCosPicker(toolBarTitle, multipleColsData: multipleColsData, defaultSelectedIndexs: defaultSelectedIndexs, cancelAction: {[unowned self] in
            clearAction?()
            self.hidePicker()
            }, doneAction: {[unowned self] (selectedIndexs, selectedValues) in
                doneAction?(selectedIndexs, selectedValues)
                self.hidePicker()
        })
        pickerView.frame = hideFrame
        addSubview(pickerView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        addGestureRecognizer(tap)
    }

    // 多列关联
    convenience init(frame: CGRect, toolBarTitle: String, multipleAssociatedColsData: MultipleAssociatedDataType, defaultSelectedValues: [String]?, clearAction: BtnAction?, doneAction: MultipleDoneAction?) {
        self.init(frame: frame)
        pickerView = PickerView.multipleAssociatedCosPicker(toolBarTitle, multipleAssociatedColsData: multipleAssociatedColsData, defaultSelectedValues: defaultSelectedValues, cancelAction: {[unowned self] in
            clearAction?()
            self.hidePicker()
            }, doneAction: {[unowned self] (selectedIndexs, selectedValues) in
                doneAction?(selectedIndexs, selectedValues)
                self.hidePicker()
        })
        pickerView.frame = hideFrame
        addSubview(pickerView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        addGestureRecognizer(tap)

    }
    // 城市选择器
    convenience init(frame: CGRect, toolBarTitle: String, type: CityPickStyle, defaultSelectedValues: [String]?, clearAction: BtnAction?, doneAction: MultipleDoneAction?) {
        self.init(frame: frame)
        pickerView = PickerView.citiesPicker(toolBarTitle, type: type, defaultSelectedValues: defaultSelectedValues, cancelAction: {[unowned self] in
            clearAction?()
            self.hidePicker()
            }, doneAction: {[unowned self] (selectedIndexs, selectedValues) in
                doneAction?(selectedIndexs, selectedValues)
                self.hidePicker()
        })
        pickerView.frame = hideFrame
        addSubview(pickerView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        addGestureRecognizer(tap)
    }
    // 日期选择器
    convenience init(frame: CGRect, toolBarTitle: String, datePickerSetting: DatePickerSetting, clearAction: BtnAction?, doneAction: DateDoneAction?) {
        self.init(frame: frame)
        pickerView = PickerView.datePicker(toolBarTitle, datePickerSetting: datePickerSetting, cancelAction: {[unowned self] in
            clearAction?()
            self.hidePicker()
            }, doneAction: {[unowned self] (selectedDate) in
                doneAction?(selectedDate)
                self.hidePicker()
        })
        pickerView.frame = hideFrame
        addSubview(pickerView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        addGestureRecognizer(tap)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addOrentationObserver()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - selector
extension PickerViewManager {

    private func addOrentationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.statusBarOrientationChange), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }

    // 屏幕旋转时移除pickerView
    @objc
    func statusBarOrientationChange() {
        removeFromSuperview()
    }

    @objc
    func tapAction(_ tap: UITapGestureRecognizer) {
        let location = tap.location(in: self)
        if location.y <= screenHeight - pickerViewHeight {
            self.hidePicker()
        }
    }
}

// MARK: - 弹出和移除self
extension PickerViewManager {

    /// 通过window 弹出view
    private func showPicker() {

        let window = UIApplication.shared.keyWindow
        guard let currentWindow = window else { return }
        currentWindow.addSubview(self)

        UIView.animate(withDuration: 0.25, animations: {[unowned self] in
            self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
            self.pickerView.frame = self.showFrame
        }, completion: nil)

    }

    /// 把self从window中移除
    func hidePicker() {

        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            self.backgroundColor = UIColor.clear
            self.pickerView.frame = self.hideFrame

        }, completion: {[unowned self] (_) in
            self.removeFromSuperview()
        })
    }
}

// MARK: - 快速使用方法
extension PickerViewManager {

    /// 单列选择器
    ///  - parameter title:                      标题
    ///  - parameter data:                       数据；数据为空时，会弹出提示框提示数据为空
    ///  - parameter defaultSeletedIndex:        默认选中的行数；传入当默认索引不在合理范围内,会默认显示第一个
    ///  - parameter doneAction:                 响应完成的Closure
    public class func showSingleColPicker(_ toolBarTitle: String, data: [String], defaultSelectedIndex: Int?, clearAction: BtnAction?, doneAction: SingleDoneAction?) {
        if data.isEmpty {
            HUD.showText("PickerViewManager.emptyData".localizedOfLTXiOSUtils())
            return
        }
        let window = UIApplication.shared.keyWindow
        guard let currentWindow = window else { return }
        currentWindow.endEditing(true)
        let pickViewManager = PickerViewManager(frame: currentWindow.bounds, toolBarTitle: toolBarTitle, singleColData: data, defaultSelectedIndex: defaultSelectedIndex, clearAction: clearAction, doneAction: doneAction)
        pickViewManager.showPicker()
    }

    /// 多列不关联选择器
    /// - Parameter toolBarTitle: 标题
    /// - Parameter data: 数据；为空时，会弹出提示框提示数据为空
    /// - Parameter defaultSelectedIndexs: 默认选中的每一列的行数；当默认索引不在合理范围内,会默认显示第一个，默认索引数组数量不做限制，已兼容
    /// - Parameter doneAction: 响应完成的Closure
    public class func showMultipleColsPicker(_ toolBarTitle: String, data: [[String]], defaultSelectedIndexs: [Int]?, clearAction: BtnAction?, doneAction: MultipleDoneAction?) {
        if data.isEmpty {
            HUD.showText("PickerViewManager.emptyData".localizedOfLTXiOSUtils())
            return
        }
        let window = UIApplication.shared.keyWindow
        guard let currentWindow = window else { return }
        currentWindow.endEditing(true)
        let pickViewManager = PickerViewManager(frame: currentWindow.bounds, toolBarTitle: toolBarTitle, multipleColsData: data, defaultSelectedIndexs: defaultSelectedIndexs, clearAction: clearAction, doneAction: doneAction)
        pickViewManager.showPicker()
    }

    /// 多列关联选择器
    /// - Parameter toolBarTitle: 标题
    /// - Parameter data: 数据；为空时，会弹出提示框提示数据为空
    /// - Parameter defaultSelectedValues: 默认选中的每一列的数值；当默认值不存在时,会默认显示第一个，默认数据数组数量不做限制，已兼容
    /// - Parameter doneAction: 响应完成的Closure
    public class func showMultipleAssociatedColsPicker(_ toolBarTitle: String, data: MultipleAssociatedDataType, defaultSelectedValues: [String]?, clearAction: BtnAction?, doneAction: MultipleDoneAction?) {
        if data.isEmpty {
            HUD.showText("PickerViewManager.emptyData".localizedOfLTXiOSUtils())
            return
        }
        let window = UIApplication.shared.keyWindow
        guard let currentWindow = window else { return }
        currentWindow.endEditing(true)
        let pickViewManager = PickerViewManager(frame: currentWindow.bounds, toolBarTitle: toolBarTitle, multipleAssociatedColsData: data, defaultSelectedValues: defaultSelectedValues, clearAction: clearAction, doneAction: doneAction)
        pickViewManager.showPicker()
    }

    /// 城市选择器
    /// - Parameter toolBarTitle:  标题
    /// - Parameter type: 显示样式类型
    /// - Parameter defaultSelectedValues: 默认选中的每一列的值, 注意不是行数；当默认值不存在时,会默认显示第一个，默认数据数组数量不做限制，已兼容
    /// - Parameter doneAction: 响应完成的Closure
    public class func showCitiesPicker(_ toolBarTitle: String, type: CityPickStyle = .province, defaultSelectedValues: [String]?, clearAction: BtnAction?, doneAction: MultipleDoneAction?) {
        let window = UIApplication.shared.keyWindow
        guard let currentWindow = window else { return }
        currentWindow.endEditing(true)
        let pickViewManager = PickerViewManager(frame: currentWindow.bounds, toolBarTitle: toolBarTitle, type: type, defaultSelectedValues: defaultSelectedValues, clearAction: clearAction, doneAction: doneAction)
        pickViewManager.showPicker()
    }

    /// 日期选择器
    /// - Parameter toolBarTitle: 标题
    /// - Parameter datePickerSetting: 可配置UIDatePicker的样式
    /// - Parameter doneAction: 响应完成的Closure
    public class func showDatePicker(_ toolBarTitle: String, datePickerSetting: DatePickerSetting = DatePickerSetting(), clearAction: BtnAction?, doneAction: DateDoneAction?) {
        let window = UIApplication.shared.keyWindow
        guard let currentWindow = window else { return }
        currentWindow.endEditing(true)
        let pickViewManager = PickerViewManager(frame: currentWindow.bounds, toolBarTitle: toolBarTitle, datePickerSetting: datePickerSetting, clearAction: clearAction, doneAction: doneAction)
        pickViewManager.showPicker()
    }

}
