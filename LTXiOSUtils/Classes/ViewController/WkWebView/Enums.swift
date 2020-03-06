

import Foundation

public enum BarButtonItemType {
    case back
    case forward
    case reload
    case stop
    case activity
    case done
    case flexibleSpace

}

public enum NavigationBarPosition {
    case none
    case left
    case right

}

@objc
public enum NavigationType: Int {
    case linkActivated
    case formSubmitted
    case backForward
    case reload
    case formResubmitted
    case other
}
