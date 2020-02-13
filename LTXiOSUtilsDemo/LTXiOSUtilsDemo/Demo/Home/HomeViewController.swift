//
//  HomeViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/2/12.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import LTXiOSUtils
import FSPagerView
import Kingfisher

class HomeViewController: BaseUIScrollViewController {

    private lazy var searchView: UIView = {
        let searchView = UIView()
        return searchView
    }()

    private lazy var searchLabel: UILabel = {
        let searchLabel = UILabel()
        return searchLabel
    }()

    private lazy var pagerView: FSPagerView = {
        let pagerView = FSPagerView()
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: FSPagerViewCell.description())
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.isInfinite = true
        return pagerView
    }()

    private lazy var pageControl: FSPageControl = {
        let pageControl = FSPageControl()
        pageControl.setFillColor(.white, for: .normal)
        pageControl.setFillColor(AppTheme.mainColor, for: .selected)
        pageControl.contentHorizontalAlignment = .center
        pageControl.hidesForSinglePage = true
        return pageControl
    }()

    private var pagerViewImageListData = JSON()

    override func viewDidLoad() {
        super.viewDidLoad()
        let leftBarItem = UIBarButtonItem(image: R.image.scan(), style: .plain, target: self, action: #selector(scan))
        let rightBarItem = UIBarButtonItem(image: R.image.message(), style: .plain, target: self, action: #selector(showMessage))
        navigationItem.leftBarButtonItem = leftBarItem
        navigationItem.rightBarButtonItem = rightBarItem
        navigationItem.titleView = getSearchView()
        // 在viewDidLoad中没法直接获取到UIBarButtonItem的实例，
        // 延长一段时间进行获取,不过一般角标都是根据后台返回的，会有一定的时间缓冲
        DispatchQueue.main.delay(0.001) {
            rightBarItem.core.addDot(color: .red)
        }
        getPagerViewData()
    }

    private func getSearchView() -> UIView {
        searchView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        searchView.frame = CGRect(x: 0, y: 0, width: 290, height: 30)
        searchView.layer.cornerRadius = 30 / 2

        let searchImageView = UIImageView()
        searchImageView.image = R.image.search()
        searchImageView.frame = CGRect(x: 10, y: 5, width: 20, height: 20)
        searchView.addSubview(searchImageView)

        searchLabel.text = "点击搜索"
        searchLabel.font = UIFont.systemFont(ofSize: 15)
        searchLabel.textColor = .white
        searchView.addSubview(searchLabel)
        searchLabel.frame = CGRect(x: 35, y: 5, width: searchView.frame.width - 45, height: 20)
        return searchView
    }

    override func setScrollSubViews(contentView: UIView) {
        contentView.addSubview(pagerView)
        pagerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(150)
            make.bottom.equalToSuperview()
        }
        contentView.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.left.right.equalTo(pagerView)
            make.top.equalTo(pagerView.snp.bottom).offset(-20)
        }
    }
}

extension HomeViewController {
    @objc func scan() {
        QL1("扫描")
    }

    @objc func showMessage() {
        QL1("查看消息")
    }
}

extension HomeViewController: FSPagerViewDataSource, FSPagerViewDelegate {

    private func getPagerViewData() {
        let requestParam = RequestParam(baseUrl: NetworkConstant.appUrl, path: NetworkConstant.bannerUrl)
        requestParam.method = .get
        NetworkManager.sendRequest(requestParam: requestParam) { data in
            self.pagerViewImageListData = data["imageList"]
            self.pagerView.automaticSlidingInterval = CGFloat(data["interval"].floatValue)
            self.pagerView.reloadData()

            self.pageControl.numberOfPages = self.pagerViewImageListData.count
            QL1(data)
        }
    }

    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return pagerViewImageListData.count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: FSPagerViewCell.description(), at: index)
        let url = pagerViewImageListData[index]["imgUrl"].stringValue
        cell.imageView?.kf.indicatorType = .activity
        cell.imageView?.kf.setImage(with: URL(string: url))
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
//        cell.textLabel?.text = ""
//        cell.textLabel?.textAlignment = .center
        cell.layer.masksToBounds = true
        return cell
    }
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        QL1(pagerViewImageListData[index]["actionUrl"])
    }

    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
           self.pageControl.currentPage = targetIndex
       }

       func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
           self.pageControl.currentPage = pagerView.currentIndex
       }
}
