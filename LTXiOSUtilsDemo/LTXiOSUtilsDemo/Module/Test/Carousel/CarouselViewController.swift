//
//  CarouselViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/10/14.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import LTXiOSUtils

class CarouselViewController: BaseUIViewController {

    let imageArr = [
        R.image.carousel_1()!,
        R.image.carousel_2()!,
        R.image.carousel_3()!
    ]

    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = imageArr.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .black
        return pageControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        setupCarouselView()
    }
}

/// 利用UIScrollView，左右各多放置一个的方法实现
/// 这种方案没有考虑view的复用，如果图片过多，内存占用过大，会出现内存溢出的问题
/// 建议确定只放置少量图片的时候使用这种方式
extension CarouselViewController: UIScrollViewDelegate {
    func setupCarouselView() {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.backgroundColor = .systemRed
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        baseView.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().dividedBy(4)
        }

        baseView.layoutIfNeeded()
        Log.d(scrollView.frame)

        let width = scrollView.bounds.size.width
        let height = scrollView.bounds.size.height

        // 第一个位置放置最后一张图片
        let imageViewFirst = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewFirst.image = imageArr.last
        scrollView.addSubview(imageViewFirst)

        for index in 0..<imageArr.count {
            let imageView = UIImageView(frame: CGRect(x: width * CGFloat((index + 1)), y: 0, width: width, height: height))
            imageView.image = imageArr[index]
            scrollView.addSubview(imageView)
        }

        let imageViewLast = UIImageView(frame: CGRect(x: width * CGFloat((imageArr.count + 1)), y: 0, width: width, height: height))
        imageViewLast.image = imageArr.first
        scrollView.addSubview(imageViewLast)

        scrollView.contentSize.width = width * CGFloat((imageArr.count + 2))
        scrollView.contentOffset = CGPoint(x: width, y: 0)

        baseView.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalToSuperview()
            make.bottom.equalTo(scrollView).offset(-10)
        }

        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .white
        label.text = "利用UIScrollView，左右各多放置一个的方法实现"
        baseView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(5)
        }

    }

    // 滑动停止
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        if scrollView.contentOffset.x == 0 {
            scrollView.contentOffset = CGPoint(x: CGFloat(imageArr.count) * width, y: 0)
            pageControl.currentPage = imageArr.count
        } else if scrollView.contentOffset.x == CGFloat((imageArr.count + 1)) * width {
            scrollView.contentOffset = CGPoint(x: width, y: 0)
            pageControl.currentPage = 0
        } else {
            pageControl.currentPage = Int(scrollView.contentOffset.x / width - 1)
        }
    }
}
