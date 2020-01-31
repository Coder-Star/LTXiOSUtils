//
//  RollingNoticeView.swift
//  LTXiOSUtils
//  上下滚动view
//  Created by 李天星 on 2020/1/31.
//

import UIKit

@objc public protocol RollingNoticeViewDataSource : NSObjectProtocol {
    func numberOfRowsFor(roolingView: RollingNoticeView) -> Int
    func rollingNoticeView(roolingView: RollingNoticeView, cellAtIndex index: Int) -> RollingNoticeCell
}

@objc public protocol RollingNoticeViewDelegate: NSObjectProtocol {
    @objc optional func rollingNoticeView(_ roolingView: RollingNoticeView, didClickAt index: Int)
}

open class RollingNoticeView: UIView {
    /// 数据
    weak open var dataSource: RollingNoticeViewDataSource?
    /// 代理
    weak open var delegate: RollingNoticeViewDelegate?
    /// 滚动间隔
    open var rollInterval = 2.0
    open private(set) var currentIndex = 0

    private lazy var cellClsDict: [String : Any] = {
        let tempDict = [String:Any]()
        return tempDict
    }()
    private lazy var reuseCells: [RollingNoticeCell] = {
        let tempArr = [RollingNoticeCell]()
        return tempArr
    }()

    private var timer: Timer?
    private var currentCell: RollingNoticeCell?
    private var willShowCell: RollingNoticeCell?
    private var isAnimating = false

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNoticeViews()
    }

    open func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        self.cellClsDict[identifier] = nib
    }

    open func register(_ cellClass: Swift.AnyClass?, forCellReuseIdentifier identifier: String) {
        self.cellClsDict[identifier] = cellClass
    }

    open func dequeueReusableCell(withIdentifier identifier: String) -> RollingNoticeCell? {
        for cell in self.reuseCells {
            guard let reuseIdentifier = cell.reuseIdentifier else { return nil }
            if reuseIdentifier.elementsEqual(identifier) {
                return cell
            }
        }

        if let cellCls = self.cellClsDict[identifier] {
            if let nib = cellCls as? UINib {
                let arr = nib.instantiate(withOwner: nil, options: nil)
                if let cell = arr.first as? RollingNoticeCell {
                    cell.setValue(identifier, forKeyPath: "reuseIdentifier")
                    return cell
                }
                return nil
            }

            if let noticeCellCls = cellCls as? RollingNoticeCell.Type {
                let cell = noticeCellCls.self.init(reuseIdentifier: identifier)
                return cell
            }
        }
        return nil
    }

    open func reloadDataAndStartRoll() {
        stopRoll()
        guard let count = self.dataSource?.numberOfRowsFor(roolingView: self), count > 0 else {
            return
        }
        layoutCurrentCellAndWillShowCell()
        guard count >= 2 else {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: rollInterval, target: self, selector: #selector(RollingNoticeView.timerHandle), userInfo: nil, repeats: true)
        if let notNilTimer = timer {
            RunLoop.current.add(notNilTimer, forMode: .common)
        }
    }

    // 停止滚动
    open func stopRoll() {
        if let rollTimer = timer {
            rollTimer.invalidate()
            timer = nil
        }
        isAnimating = false
        currentIndex = 0
        currentCell?.removeFromSuperview()
        willShowCell?.removeFromSuperview()
        currentCell = nil
        willShowCell = nil
        self.reuseCells.removeAll()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNoticeViews()
    }

    deinit {
        stopRoll()
    }
}

// MARK: private funcs
extension RollingNoticeView {

    @objc private func timerHandle() {
        if isAnimating {
            return
        }
        layoutCurrentCellAndWillShowCell()
        currentIndex += 1
        let w = self.frame.size.width
        let h = self.frame.size.height

        isAnimating = true
        UIView.animate(withDuration: 0.5, animations: {
            self.currentCell?.frame = CGRect(x: 0, y: -h, width: w, height: h)
            self.willShowCell?.frame = CGRect(x: 0, y: 0, width: w, height: h)
        }, completion: { _ in
            if let cell0 = self.currentCell, let cell1 = self.willShowCell {
                self.reuseCells.append(cell0)
                cell0.removeFromSuperview()
                self.currentCell = cell1
            }
            self.isAnimating = false
        })
    }

    private func layoutCurrentCellAndWillShowCell() {
        guard let count = (self.dataSource?.numberOfRowsFor(roolingView: self)) else { return }

        if currentIndex > count - 1 {
            currentIndex = 0
        }

        var willShowIndex = currentIndex + 1
        if willShowIndex > count - 1 {
            willShowIndex = 0
        }
        let w = self.frame.size.width
        let h = self.frame.size.height
        if currentCell == nil {
            if let cell = self.dataSource?.rollingNoticeView(roolingView: self, cellAtIndex: currentIndex) {
                currentCell = cell
                cell.frame  = CGRect(x: 0, y: 0, width: w, height: h)
                self.addSubview(cell)
            }
            return
        }

        if let cell = self.dataSource?.rollingNoticeView(roolingView: self, cellAtIndex: willShowIndex) {
            willShowCell = cell
            cell.frame = CGRect(x: 0, y: h, width: w, height: h)
            self.addSubview(cell)
        }

        guard let notNilCurrentCell = currentCell, let notNilWillShowCell = willShowCell else {
            return
        }
        let currentCellIdx = self.reuseCells.firstIndex(of: notNilCurrentCell)
        let willShowCellIdx = self.reuseCells.firstIndex(of: notNilWillShowCell)

        if let index = currentCellIdx {
            self.reuseCells.remove(at: index)
        }

        if let index = willShowCellIdx {
            self.reuseCells.remove(at: index)
        }
    }

    private func setupNoticeViews() {
        self.clipsToBounds = true
        self.addTapGesture { _ in
            guard let count = self.dataSource?.numberOfRowsFor(roolingView: self) else {
                return
            }
            if self.currentIndex > count - 1 {
                self.currentIndex = 0
            }
            self.delegate?.rollingNoticeView?(self, didClickAt: self.currentIndex)
        }
    }
}

open class RollingNoticeCell: UIView {

    @objc open private(set) var reuseIdentifier: String?

    /// 标题
    public lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        return titleLabel
    }()

    public required init(reuseIdentifier: String?) {
        self.reuseIdentifier = reuseIdentifier
        super.init(frame: .zero)
        self.addSubview(titleLabel)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
