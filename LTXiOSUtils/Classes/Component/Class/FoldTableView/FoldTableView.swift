import UIKit

open class FoldTableView: UITableView {

    // MARK: - private
    private weak var foldDataSource: FoldTableViewDataSource?
    private weak var foldDelegate: FoldTableViewDelegate?

    // MARK: - public
    public private(set) var expandedSections: [Int: Bool] = [:]
    open var expandingAnimation: UITableView.RowAnimation = .fade
    open var collapsingAnimation: UITableView.RowAnimation = .fade

    open override var dataSource: UITableViewDataSource? {
        get { return super.dataSource }
        set(dataSource) {
            guard let dataSource = dataSource else { return }
            foldDataSource = dataSource as? FoldTableViewDataSource
            super.dataSource = self
        }
    }

    open override var delegate: UITableViewDelegate? {
        get { return super.delegate }
        set(delegate) {
            guard let delegate = delegate else { return }
            foldDelegate = delegate as? FoldTableViewDelegate
            super.delegate = self
        }
    }

    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        if foldDelegate == nil {
            super.delegate = self
        }
    }
}

extension FoldTableView {
    /// 展开指定section
    /// - Parameter section: section索引
    public func expand(_ section: Int) {
        animate(with: .expand, forSection: section)
    }

    /// 折叠指定section
    /// - Parameter section: section索引
    public func collapse(_ section: Int) {
        animate(with: .collapse, forSection: section)
    }

    private func animate(with type: FoldActionType, forSection section: Int) {
        guard canExpand(section) else { return }
        let sectionIsExpanded = didExpand(section)
        if ((type == .expand) && (sectionIsExpanded)) || ((type == .collapse) && (!sectionIsExpanded)) { return }
        assign(section, asExpanded: (type == .expand))
        startAnimating(self, with: type, forSection: section)
    }

    private func startAnimating(_ tableView: FoldTableView, with type: FoldActionType, forSection section: Int) {
        let headerCell = (self.cellForRow(at: IndexPath(row: 0, section: section)))
        let headerCellConformant = headerCell as? FoldTableViewHeaderCell

        CATransaction.begin()
        headerCell?.isUserInteractionEnabled = false

        headerCellConformant?.changeState((type == .expand ? .willExpand : .willCollapse), cellReuseStatus: false)
        foldDelegate?.tableView(tableView, FoldState: (type == .expand ? .willExpand : .willCollapse), changeForSection: section)

        CATransaction.setCompletionBlock {
            headerCellConformant?.changeState((type == .expand ? .didExpand : .didCollapse), cellReuseStatus: false)
            self.foldDelegate?.tableView(tableView, FoldState: (type == .expand ? .didExpand : .didCollapse), changeForSection: section)
            headerCell?.isUserInteractionEnabled = true
        }

        self.beginUpdates()

        if let sectionRowCount = foldDataSource?.tableView(tableView, numberOfRowsInSection: section), sectionRowCount > 1 {
            var indexesToProcess: [IndexPath] = []
            for row in 1..<sectionRowCount {
                indexesToProcess.append(IndexPath(row: row, section: section))
            }
            if type == .expand {
                self.insertRows(at: indexesToProcess, with: expandingAnimation)
            } else if type == .collapse {
                self.deleteRows(at: indexesToProcess, with: collapsingAnimation)
            }
        }
        self.endUpdates()
        CATransaction.commit()
    }
}

extension FoldTableView: UITableViewDataSource {
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = foldDataSource?.tableView(self, numberOfRowsInSection: section) ?? 0

        guard canExpand(section) else { return numberOfRows }
        guard numberOfRows != 0 else { return 0 }

        return didExpand(section) ? numberOfRows : 1
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// 每个section的第一个cell为折叠的cell
        guard canExpand(indexPath.section), indexPath.row == 0 else {
            return foldDataSource!.tableView(tableView, cellForRowAt: indexPath)
        }

        let headerCell = foldDataSource!.tableView(self, expandableCellForSection: indexPath.section)

        guard let headerCellConformant = headerCell as? FoldTableViewHeaderCell else {
            return headerCell
        }

        // cell复用时，需要重新刷新折叠状态
        DispatchQueue.main.async {
            if self.didExpand(indexPath.section) {
                headerCellConformant.changeState(.willExpand, cellReuseStatus: true)
                headerCellConformant.changeState(.didExpand, cellReuseStatus: true)
            } else {
                headerCellConformant.changeState(.willCollapse, cellReuseStatus: true)
                headerCellConformant.changeState(.didCollapse, cellReuseStatus: true)
            }
        }
        return headerCell
    }
}

extension FoldTableView: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        foldDelegate?.tableView?(tableView, didSelectRowAt: indexPath)
        guard canExpand(indexPath.section), indexPath.row == 0 else { return }
        didExpand(indexPath.section) ? collapse(indexPath.section) : expand(indexPath.section)
    }
}

extension FoldTableView {
    private func canExpand(_ section: Int) -> Bool {
        return foldDataSource?.tableView(self, canExpandSection: section) ?? true
    }

    private func didExpand(_ section: Int) -> Bool {
        return expandedSections[section] ?? false
    }

    private func assign(_ section: Int, asExpanded: Bool) {
        expandedSections[section] = asExpanded
    }
}

extension FoldTableView {
    private func verifyProtocol(_ aProtocol: Protocol, contains aSelector: Selector) -> Bool {
        return protocol_getMethodDescription(aProtocol, aSelector, true, true).name != nil || protocol_getMethodDescription(aProtocol, aSelector, false, true).name != nil
    }

    override open func responds(to aSelector: Selector!) -> Bool {
        if verifyProtocol(UITableViewDataSource.self, contains: aSelector) {
            return (super.responds(to: aSelector)) || (foldDataSource?.responds(to: aSelector) ?? false)

        } else if verifyProtocol(UITableViewDelegate.self, contains: aSelector) {
            return (super.responds(to: aSelector)) || (foldDelegate?.responds(to: aSelector) ?? false)
        }
        return super.responds(to: aSelector)
    }

    override open func forwardingTarget(for aSelector: Selector!) -> Any? {
        if verifyProtocol(UITableViewDataSource.self, contains: aSelector) {
            return foldDataSource

        } else if verifyProtocol(UITableViewDelegate.self, contains: aSelector) {
            return foldDelegate
        }
        return super.forwardingTarget(for: aSelector)
    }
}
