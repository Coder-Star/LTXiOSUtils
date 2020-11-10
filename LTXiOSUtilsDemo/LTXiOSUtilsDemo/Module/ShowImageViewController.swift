//
//  ShowImageViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/11/9.
//  Copyright © 2020 李天星. All rights reserved.
//

import UIKit
import LTXiOSUtils
import SwiftSVG
import SVGKit
import Kingfisher

class ShowImageViewController: BaseUIScrollViewController {

    private let leftWidth = 110

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "展示图片"
    }

    override func setContentViewSubViews(contentView: UIView) {
        var titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.numberOfLines = 0
        titleLabel.text = "加载多语言图片(不同语言环境下显示图片不同)"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(leftWidth)
        }

        var imageView = UIImageView()
        // addImage.png为直接拖动到项目中的图片，没有放置到xcassets中去，也可直接读取 chinese_and_english以及chinese_and_english.png都可以读取
        // chinese_and_english.png为多环境图片，包含两套图片
        // 加载png图片不用添加后缀，加载其他格式的图片，如jpg必须要添加后缀
        imageView.image = UIImage(named: "chinese_and_english")
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.top.equalTo(titleLabel)
        }

        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.numberOfLines = 0
        titleLabel.text = "加载组件图片"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.width.equalTo(leftWidth)
        }

        imageView = UIImageView()
        // Assets.xcassets中的图片资源只能通过imageNamed:方法加载
        imageView.image = UIImage.tx.getImage(named: "AlertView_selected", bundleName: "LTXiOSUtils")
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.top.equalTo(titleLabel)
        }

//        titleLabel = UILabel()
//        titleLabel.textAlignment = .center
//        titleLabel.lineBreakMode = .byCharWrapping
//        titleLabel.numberOfLines = 0
//        titleLabel.text = "SwiftSVG"
//        contentView.addSubview(titleLabel)
//        titleLabel.snp.makeConstraints { make in
//            make.left.equalToSuperview()
//            make.top.equalTo(imageView.snp.bottom).offset(10)
//            make.width.equalTo(leftWidth)
//        }
//
//        let svgView = UIView(SVGNamed: "")
//        contentView.addSubview(svgView)
//        svgView.snp.makeConstraints { make in
//            make.height.width.equalTo(10)
//            make.left.equalTo(titleLabel.snp.right).offset(5)
//            make.top.equalTo(titleLabel)
//        }

        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.numberOfLines = 0
        titleLabel.text = "SVGKit"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.width.equalTo(leftWidth)
        }

        imageView = UIImageView()
        imageView.image = UIImage.svgImage(named: "tap-add", color: UIColor(named: "base-color"))
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.top.equalTo(titleLabel)
        }

        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.numberOfLines = 0
        titleLabel.text = "远程SVG"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.width.equalTo(leftWidth)
        }

        imageView = UIImageView()
        let url = URL(string: "http://121.36.20.56:8080/LTXiOSUtils/map.svg")
        imageView.kf.setSVGImage(with: url!)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.top.equalTo(titleLabel)
        }

        imageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }

    }

}

extension UIImage {
    /// 获取SVG图片，如果没有name对应的svg图片，则加载普通格式图片
    /// - Parameters:
    ///   - named: svg图片名称
    ///   - color: svg图片颜色，如果为nil，保持原色
    public static func svgImage(named: String, color: UIColor?) -> UIImage? {
        var image: UIImage?
        do {
            try OCExceptionCatch.catchException {
                /**
                 当不存在named对应的svg图片时，会产生NSInternalInconsistencyException异常，造成闪退
                 所以需要利用OC捕获异常
                 */
                if let svgKImage = SVGKImage(named: named) {
                    if let color = color {
                        image = svgKImage.uiImage.withTintColor(color: color)
                    } else {
                        image = svgKImage.uiImage
                    }
                } else {
                    image = UIImage(named: named)
                }
            }
        } catch let error {
            Log.d(error)
            image = UIImage(named: named)
        }
        return image
    }

    /// 修改UIImage的颜色
    /// - Parameter color: 修改成的颜色
    /// - Returns: 修改颜色后的UIImage
    public func withTintColor(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContext(self.size)
        color.setFill()
        let bounds = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        self.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }
}

// MARK: - SVGKit与Kingfisher结合实现远程svg加载
struct SVGProcessor: ImageProcessor {
    var identifier: String {
        return "com.star.LTXiOSUtils"
    }

    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image
        case .data(let data):
            let img = SVGKImage(data: data)?.uiImage
            return img
        }
    }
}

extension KingfisherWrapper where Base: KFCrossPlatformImageView {
    func setSVGImage(with resource: Resource) {
        setImage(with: resource, options: [.processor(SVGProcessor())])
    }
}
