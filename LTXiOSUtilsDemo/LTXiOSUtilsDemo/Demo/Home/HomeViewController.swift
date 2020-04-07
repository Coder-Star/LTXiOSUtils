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
import SafariServices

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

    private var menu = [
        GridMenuItem(code: "1", title: "小金库", image: R.image.home_button_bmfw(), markType: .none),
        GridMenuItem(code: "2", title: "集贸", image: R.image.home_button_jmsc(), markType: .point(isShow: true)),
        GridMenuItem(code: "3", title: "旅游", image: R.image.home_button_mlxc(), markType: .text(text: "角标")),
        GridMenuItem(code: "4", title: "名优", image: R.image.home_button_myzq(), markType: .number(number: 4)),
        GridMenuItem(code: "5", title: "农场", image: R.image.home_button_nczg(), markType: .number(number: 5)),
        GridMenuItem(code: "6", title: "分类", image: R.image.home_button_nyjs(), markType: .number(number: 6)),
        GridMenuItem(code: "7", title: "热点", image: R.image.home_button_nyq(), markType: .number(number: 7)),
        GridMenuItem(code: "8", title: "行情", image: R.image.home_button_schq(), markType: .number(number: 8)),
        GridMenuItem(code: "9", title: "商城", image: R.image.home_button_shop(), markType: .number(number: 9)),
        GridMenuItem(code: "10", title: "视频", image: R.image.home_button_xsp(), markType: .number(number: 10)),
        GridMenuItem(code: "11", title: "阅读", image: R.image.home_button_xwzc(), markType: .number(number: 11))
    ]

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

    override func setContentViewSubViews(contentView: UIView) {
        contentView.addSubview(pagerView)
        pagerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(150)
        }
        contentView.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.left.right.equalTo(pagerView)
            make.top.equalTo(pagerView.snp.bottom).offset(-20)
        }

        contentView.layoutIfNeeded()
        let scrollMenView = GridMenuView(width: contentView.width, row: 2, col: 5, menu: menu, mode: .horizontalScroll, pageStyle: PageControlStyle.ring(circleSize: 5))
        scrollMenView.backgroundColor = UIColor(hexString: "#eeeeee")
        scrollMenView.pageControlNormorlColor = .lightGray
        scrollMenView.delegate = self
        contentView.addSubview(scrollMenView)
        scrollMenView.snp.makeConstraints { make in
            make.top.equalTo(pagerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(scrollMenView.heightInfo)
            make.bottom.equalToSuperview()
        }
    }
}

extension HomeViewController {
    @objc func scan() {
        Log.d("扫描")
        guard let className = "HomeViewController".class as? UIViewController.Type else {
            return
        }
        let target = className.init()
//        let action = #selector(actionInfo(info:))
        let action = NSSelectorFromString("actionInfo:")
        let info = ["1": "2"]
        if target.responds(to: action) {
            target.perform(action, with: info)
        }
    }

    @objc func showMessage() {
        Log.d("查看消息")
    }

    @objc
    func actionInfo(_ info: [String: Any]) {
        Log.d(info)
    }
}

extension HomeViewController: FSPagerViewDataSource, FSPagerViewDelegate {

    private func getPagerViewData() {
        var requestParam = RequestParam(baseUrl: NetworkConstant.appUrl, path: NetworkConstant.bannerUrl)
        requestParam.hud.isShow = false
        requestParam.ignoreError = true
        requestParam.method = .get
        NetworkManager.sendRequest(requestParam: requestParam) { data in
            let json = JSON(data)
            self.pagerViewImageListData = json["imageList"]
            self.pagerView.automaticSlidingInterval = CGFloat(json["interval"].floatValue)
            self.pagerView.reloadData()
            self.pageControl.numberOfPages = self.pagerViewImageListData.count
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
        Log.d(pagerViewImageListData[index]["actionUrl"])
        guard let url = URL(string: pagerViewImageListData[index]["actionUrl"].stringValue) else {
            return
        }
        let viewController = SFSafariViewController(url: url)
        present(viewController, animated: true, completion: nil)
    }

    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }

    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
}

extension HomeViewController: GridMenuViewItemDelegate {
    func gridMenuView(_ gridMenuView: GridMenuView, selectedItemAt index: Int) {
        Log.d(index)
    }
}
