import Foundation

/// cell折叠状态
public enum FoldState: Int {
    /// 即将展开
    case willExpand
    /// 即将折叠
    case willCollapse
    /// 展开完毕
    case didExpand
    /// 折叠完毕
    case didCollapse
}

/// 动作状态
public enum FoldActionType {
    /// 展开
    case expand
    /// 折叠
    case collapse
}

/// 折叠Cell需要继承该协议
public protocol FoldTableViewHeaderCell: AnyObject {
    ///
    /// - Parameters:
    ///   - state: 折叠状态
    ///   - cellReuse: 是否因为复用导致的折叠状态变化
    func changeState(_ state: FoldState, cellReuseStatus cellReuse: Bool)
}

public protocol FoldTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: FoldTableView, canExpandSection section: Int) -> Bool
    func tableView(_ tableView: FoldTableView, expandableCellForSection section: Int) -> UITableViewCell
}

public extension FoldTableViewDataSource {
    /// 是否允许展开协议默认实现，默认允许展开
    func tableView(_ tableView: FoldTableView, canExpandSection section: Int) -> Bool {
        return true
    }
}

public protocol FoldTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: FoldTableView, FoldState state: FoldState, changeForSection section: Int)
}

public extension FoldTableViewDelegate {
    /// cell折叠状态改变默认实现
    func tableView(_ tableView: FoldTableView, FoldState state: FoldState, changeForSection section: Int) {}
}
