import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    enum MultipleColumn: UInt {
        case none = 0
        case center = 1
        case rowCenter = 2
        case fill = 3
        case aspectFill = 4
    }
    
    var multipleColumn: MultipleColumn = .none
    
    @IBInspectable
    var multipleColumnIndex: UInt = 0 {
        didSet {
            multipleColumn = MultipleColumn(rawValue: multipleColumnIndex) ?? .none
        }
    }
    
    @IBInspectable
    var preferredItemSize: CGSize = .zero
    
    @IBInspectable
    var cellHeightExtent: CGFloat = 0.0
    
    @IBInspectable
    var margin: CGSize = .zero
    
    @IBInspectable
    var spacing: CGSize = .zero
    
    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else { return }
        
        if scrollDirection == .horizontal {
            minimumInteritemSpacing = spacing.height
            minimumLineSpacing = spacing.width
            
            itemSize = CGSize(width: preferredItemSize.width, height: preferredItemSize.height)
            return
        } else {
            minimumInteritemSpacing = spacing.width
            minimumLineSpacing = spacing.height
        }
        
        var availableWidth = cv.bounds.size.width - (margin.width * 2.0)
        
        if #available(iOS 11.0, *) {
            switch sectionInsetReference {
            case .fromContentInset:
                availableWidth = availableWidth - (cv.contentInset.left + cv.contentInset.right)
            case .fromSafeArea:
                availableWidth = availableWidth - (cv.safeAreaInsets.left + cv.safeAreaInsets.right)
            case .fromLayoutMargins:
                availableWidth = availableWidth - (cv.layoutMargins.left + cv.layoutMargins.right)
            default:
                break
            }
        }
        
        switch multipleColumn {
        case .none:
            itemSize = CGSize(width: availableWidth , height: preferredItemSize.height)
        case .center:
            var numColumns = max(1, Int(availableWidth / preferredItemSize.width))
            let spaceWidth = spacing.width * CGFloat(numColumns - 1)
            var cellsWidth = preferredItemSize.width * CGFloat(numColumns)
            
            if numColumns > 1, (spaceWidth + cellsWidth) > availableWidth {
                numColumns = numColumns - 1
                cellsWidth = preferredItemSize.width * CGFloat(numColumns)
            }
            
            availableWidth = availableWidth - cellsWidth
            
            let diff = floor(availableWidth / CGFloat(numColumns + 1))

            sectionInset = UIEdgeInsets(top: margin.height, left: margin.width + diff, bottom: margin.height, right: margin.width + diff)
            
            itemSize = CGSize(width: preferredItemSize.width, height: preferredItemSize.height)
        case .rowCenter:
            let numColumns = max(1, Int(availableWidth / preferredItemSize.width))
            var filledWidth = (preferredItemSize.width * CGFloat(numColumns)) + (spacing.width * CGFloat(numColumns - 1))

            if numColumns > 1, filledWidth > availableWidth {
                filledWidth = (preferredItemSize.width * CGFloat(numColumns - 1)) + (spacing.width * CGFloat(numColumns - 2))
            }
            
            availableWidth = availableWidth - filledWidth
            
            let diff = floor(availableWidth / 2.0)
            sectionInset = UIEdgeInsets(top: margin.height, left: margin.width + diff, bottom: margin.height, right: margin.width + diff)
            
            itemSize = CGSize(width: preferredItemSize.width, height: preferredItemSize.height)
        case .fill:
            let numColumns = max(1, Int(availableWidth / preferredItemSize.width))
            let spaceWidth = spacing.width * CGFloat(numColumns - 1)
            let availableWidth = availableWidth - spaceWidth
            let cellWidth = floor(availableWidth / CGFloat(numColumns))
            
            itemSize = CGSize(width: cellWidth, height: preferredItemSize.height)
        case .aspectFill:
            let numColumns = max(1, Int(availableWidth / preferredItemSize.width))
            let spaceWidth = spacing.width * CGFloat(numColumns - 1)
            let availableWidth = availableWidth - spaceWidth
            let cellWidth = floor(availableWidth / CGFloat(numColumns))
            
            let aspect = preferredItemSize.height / preferredItemSize.width
            
            itemSize = CGSize(width: cellWidth, height: (cellWidth * aspect) + cellHeightExtent)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let view = collectionView else { return false }
        return view.bounds.width != newBounds.width
    }
    
}

class PagedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    @IBInspectable
    var currentPage: Int {
        get {
            return internalCurrentPage
        }
        set {
            internalCurrentPage = newValue
            
            if let pc = pageControl {
                pc.currentPage = internalCurrentPage
            }
            
            if let cv = collectionView {
                if scrollDirection == .vertical {
                    cv.contentOffset = CGPoint(x: 0.0, y: cv.bounds.height * CGFloat(internalCurrentPage))
                } else {
                    cv.contentOffset = CGPoint(x: cv.bounds.width * CGFloat(internalCurrentPage), y: 0.0)
                }
            }
        }
    }
    
    @IBInspectable
    var numberOfPages: Int = 0 {
        didSet {
            if let pc = pageControl {
                pc.numberOfPages = numberOfPages
            }
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl?

    private var internalCurrentPage: Int = 0
    
    func setCurrentPage(_ page: Int, animated: Bool) {
        internalCurrentPage = page
        
        if let pc = pageControl {
            pc.currentPage = internalCurrentPage
        }
        
        if let cv = collectionView {
            if scrollDirection == .vertical {
                cv.setContentOffset(CGPoint(x: 0.0, y: cv.bounds.height * CGFloat(internalCurrentPage)), animated: animated)
            } else {
                cv.setContentOffset(CGPoint(x: cv.bounds.width * CGFloat(internalCurrentPage), y: 0.0), animated: animated)
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else { return }
    
        numberOfPages = cv.numberOfItems(inSection: 0)
        
        minimumInteritemSpacing = 0.0
        minimumLineSpacing = 0.0
        
        itemSize = cv.bounds.size
        sectionInset = .zero
        
        estimatedItemSize = .zero
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let cv = collectionView else { return proposedContentOffset }
        
        if scrollDirection == .vertical {
            internalCurrentPage = Int(floor(proposedContentOffset.y / cv.bounds.height))
        } else {
            internalCurrentPage = Int(floor(proposedContentOffset.x / cv.bounds.width))
        }
        
        if let pc = pageControl {
            pc.currentPage = internalCurrentPage
        }
        
        return proposedContentOffset
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard let cv = collectionView else { return proposedContentOffset }
     
        if scrollDirection == .vertical {
            return CGPoint(x: proposedContentOffset.x, y: cv.bounds.size.height * CGFloat(currentPage))
        } else {
            return CGPoint(x: cv.bounds.size.width * CGFloat(currentPage), y: proposedContentOffset.y)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let cv = collectionView else { return false }
        
        if cv.bounds != newBounds {
            itemSize = newBounds.size
            return true
        }
        
        return false
    }
    
}
