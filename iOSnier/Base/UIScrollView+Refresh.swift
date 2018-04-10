import UIKit
import MJRefresh
//
//
//
extension UIScrollView {
    
    var hh: MJRefreshHeader {
        return MJRefreshHeader()
    }
    
    var ff: MJRefreshFooter {
        return MJRefreshFooter()
    }
//
    func addHeaderRefresh(handle: @escaping Action) {
//        configRefreshHeader(with: DefaultRefreshHeader.header(), action: handle)
//        configRefreshHeader(with: ElasticRefreshHeader(), action: handle)
        hh.refreshingBlock = handle
        self.mj_header = hh
    }
//
    func addFooterRefresh(handle: @escaping Action) {
        ff.refreshingBlock = handle
        self.mj_footer = ff
    }
//
//    func endHeaderRefresh() {
//        switchRefreshHeader(to: HeaderRefresherState.normal(.none, 0))
//        switchRefreshFooter(to: .normal)
//    }
//
//    func endFooterRefresh(showNoMore: Bool = false) {
//        switchRefreshFooter(to: .normal)
//        
//        if showNoMore {
//            switchRefreshFooter(to: .noMoreData)
//        }
//    }
//
    func endRefresh(showNoMore: Bool = false) {

     
    }
//
}
