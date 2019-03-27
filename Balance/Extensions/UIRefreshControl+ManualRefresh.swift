import UIKit

// Modified from https://stackoverflow.com/a/35468501/299262
extension UIRefreshControl {
    func beginRefreshingManually() {
        beginRefreshing()
        if let scrollView = superview as? UIScrollView, scrollView.contentOffset.y == 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: true)
        }
    }
}
