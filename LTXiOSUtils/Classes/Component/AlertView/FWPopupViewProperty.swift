//
//  FWPopupViewProperty.swift
//  LTXiOSUtils
//
//  Created by 李天星 on 2020/2/14.
//

import Foundation

open class FWPopupViewProperty: NSObject {
    /// 标题字体大小
    @objc
    open var titleFontSize: CGFloat = 18.0
    /// 标题字体，设置该值后titleFontSize无效
    @objc
    open var titleFont: UIFont?
    /// 标题文字颜色
    @objc
    open var titleColor: UIColor = kPV_RGBA(r: 51, g: 51, b: 51, a: 1)

    /// 按钮字体大小
    @objc
    open var buttonFontSize: CGFloat = 17.0
    /// 按钮字体，设置该值后buttonFontSize无效
    @objc
    open var buttonFont: UIFont?
    /// 按钮高度
    @objc
    open var buttonHeight: CGFloat = 48.0
    /// 普通按钮文字颜色
    @objc
    open var itemNormalColor: UIColor = kPV_RGBA(r: 51, g: 51, b: 51, a: 1)
    /// 高亮按钮文字颜色
    @objc
    open var itemHighlightColor: UIColor = kPV_RGBA(r: 254, g: 226, b: 4, a: 1)
    /// 选中按钮文字颜色
    @objc
    open var itemPressedColor: UIColor = kPV_RGBA(r: 240, g: 240, b: 240, a: 1)

    /// 单个控件中的文字（图片）等与该控件上（下）之前的距离。注意：这个距离指的是单个控件内部哦，不是控件与控件之间
    @objc
    open var topBottomMargin: CGFloat = 10
    /// 单个控件中的文字（图片）等与该控件左（右）之前的距离。注意：这个距离指的是单个控件内部哦，不是控件与控件之间
    @objc
    open var letfRigthMargin: CGFloat = 10
    /// 控件之间的间距
    @objc
    open var commponentMargin: CGFloat = 10

    /// 边框颜色（部分控件分割线也用这个颜色）
    @objc
    open var splitColor: UIColor = kPV_RGBA(r: 231, g: 231, b: 231, a: 1)
    /// 分割线、边框的宽度
    @objc
    open var splitWidth: CGFloat = (1/UIScreen.main.scale)
    /// 圆角值
    @objc
    open var cornerRadius: CGFloat = 5.0

    /// 弹窗的背景色（注意：这边指的是弹窗而不是遮罩层，遮罩层背景色的设置是：fwMaskViewColor）
    @objc
    open var backgroundColor: UIColor?
    /// 弹窗的背景渐变色：当未设置backgroundColor时该值才有效
    @objc
    open var backgroundLayerColors: [UIColor]?
    /// 弹窗的背景渐变色相关属性：当设置了backgroundLayerColors时该值才有效
    @objc
    open var backgroundLayerStartPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    /// 弹窗的背景渐变色相关属性：当设置了backgroundLayerColors时该值才有效
    @objc
    open var backgroundLayerEndPoint: CGPoint = CGPoint(x: 1.0, y: 0.0)
    /// 弹窗的背景渐变色相关属性：当设置了backgroundLayerColors时该值才有效
    @objc
    open var backgroundLayerLocations: [NSNumber] = [0, 1]

    /// 弹窗的最大高度占遮罩层高度的比例，0：表示不限制
    @objc
    open var popupViewMaxHeightRate: CGFloat = 0.6

    /// 弹窗箭头的样式
    @objc
    open var popupArrowStyle = FWMenuArrowStyle.none
    /// 弹窗箭头的尺寸
    @objc
    open var popupArrowSize = CGSize(width: 28, height: 12)
    /// 弹窗箭头的顶点的X值相对于弹窗的宽度，默认在弹窗X轴的一半，因此设置范围：0~1
    @objc
    open var popupArrowVertexScaleX: CGFloat = 0.5
    /// 弹窗圆角箭头的圆角值
    @objc
    open var popupArrowCornerRadius: CGFloat = 2.5
    /// 弹窗圆角箭头与边线交汇处的圆角值
    @objc
    open var popupArrowBottomCornerRadius: CGFloat = 4.0

    // MARK: - 自定义弹窗（继承FWPopupView）时可能会用到
    /// 弹窗校准位置
    @objc
    open var popupCustomAlignment: FWPopupCustomAlignment = .center
    /// 弹窗动画类型
    @objc
    open var popupAnimationType: FWPopupAnimationType = .position

    /// 弹窗偏移量
    @objc
    open var popupViewEdgeInsets = UIEdgeInsets.zero
    /// 遮罩层的背景色（也可以使用fwMaskViewColor），注意：该参数在弹窗隐藏后，还原为弹窗弹起时的值
    @objc
    open var maskViewColor: UIColor?
    /// 为了兼容OC，0表示false，1表示true，
    /// 为true时：用户点击外部遮罩层页面可以消失，注意：该参数在弹窗隐藏后，还原为弹窗弹起时的值
    @objc
    open var touchWildToHide: String? = "1"

    /// 显示、隐藏动画所需的时间
    @objc
    open var animationDuration: TimeInterval = 0.2
    /// 阻尼系数，范围：0.0f~1.0f，数值越小「弹簧」的振动效果越明显。默认：-1，表示没有「弹簧」效果
    @objc
    open var usingSpringWithDamping: CGFloat = -1
    /// 初始速率，数值越大一开始移动越快，默认为：5
    @objc
    open var initialSpringVelocity: CGFloat = 5

    /// 3D放射动画（当且仅当：popupAnimationType == .scale3D 时有效）
    @objc
    open var transform3D: CATransform3D = CATransform3DMakeScale(1.2, 1.2, 1.0)
    /// 2D放射动画
    @objc
    open var transform: CGAffineTransform = CGAffineTransform(scaleX: 0.001, y: 0.001)

    public override init() {
        super.init()
        self.reSetParams()
    }

    /// 属性初始化，子类重写
    /// 如果发现部分属性设置后没有生效，可执行该方法
    @objc
    public func reSetParams() {
    }
}

/// FWAlertView的相关属性
open class FWAlertViewProperty: FWPopupViewProperty {
    /// FWAlertView宽度
    @objc
    open var alertViewWidth: CGFloat = 275.0
    /// 为保持FWAlertView美观，设置FWAlertView的最小高度
    @objc
    open var alertViewMinHeight: CGFloat = 150

    /// 描述字体大小
    @objc
    open var detailFontSize: CGFloat = 14.0
    /// 描述字体，设置该值后detailFontSize无效
    @objc
    open var detailFont: UIFont?
    /// 描述文字颜色
    @objc
    open var detailColor: UIColor = kPV_RGBA(r: 51, g: 51, b: 51, a: 1)

    /// 输入框提示文字颜色
    @objc
    open var inputPlaceholderColor: UIColor = UIColor.lightGray
    /// 输入框文字颜色
    @objc
    open var inputTextColor: UIColor = kPV_RGBA(r: 51, g: 51, b: 51, a: 1)

    /// 确定按钮默认名称
    @objc
    open var defaultTextOK = "知道了"
    /// 取消按钮默认名称
    @objc
    open var defaultTextCancel = "取消"
    /// 确定按钮默认名称
    @objc
    open var defaultTextConfirm = "确定"
}

/// FWSheetView的相关属性
open class FWSheetViewProperty: FWPopupViewProperty {

    /// 取消按钮距离头部的距离
    @objc
    public var cancelBtnMarginTop: CGFloat = 6
    /// 取消按钮名称
    @objc
    public var cancelItemTitle = "取消"
    /// 取消按钮字体颜色
    @objc
    public var cancelItemTitleColor: UIColor?
    /// 取消按钮字体大小
    @objc
    public var cancelItemTitleFont: UIFont?
    /// 取消按钮背景颜色
    @objc
    public var cancelItemBackgroundColor: UIColor?

    public override func reSetParams() {
        super.reSetParams()
        self.backgroundColor = kPV_RGBA(r: 230, g: 230, b: 230, a: 1)
    }
}
