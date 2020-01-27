import UIKit

struct CollectionView: View {
    
    typealias CoreView = DCollectionView
    
    let update: (CoreView) -> Void
    
    let layout: UICollectionViewLayout
    let selectedColor: UIColor?
    let count: Int
    let content: ((Int) -> View)?
    
    init(_ update: @escaping (CoreView) -> Void, layout: UICollectionViewLayout) {
        self.update = update
        
        self.layout = layout
        self.selectedColor = nil
        self.count = 0
        self.content = nil
    }
    
    init(_ update: @escaping (CoreView) -> Void, layout: UICollectionViewLayout, selectedColor: UIColor? = nil, count: Int = 0, content: @escaping (Int) -> View) {
        self.update = update
        
        self.layout = layout
        self.selectedColor = selectedColor
        self.count = count
        self.content = content
    }
    
}

extension CollectionView {
    
    func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
        let uiview: CoreView
        let path = uiviewPath(path)
        
        if let v = hosting.reuseUIView(path) {
            uiview = v as! CoreView
        } else {
            uiview = CoreView(frame: .zero, collectionViewLayout: layout)
            uiview.backgroundColor = .clear
            uiview.contentInsetAdjustmentBehavior = .never
            
            hosting.cacheUIView(uiview, path: path)
            
            DispatchQueue.main.async {
                uiview.contentOffset = CGPoint(x: 0.0, y: -uiview.contentInset.top)
            }
        }
        
        if let c = content {
            uiview.selectedColor = selectedColor
            uiview.count = count
            uiview.content = c
            
            uiview.register(Cell.self, forCellWithReuseIdentifier: "cell")
            uiview.dataSource = uiview
        } else {
            uiview.register(nil as UINib?, forCellWithReuseIdentifier: "cell")
        }
        
        update(uiview)
        
        uiview.reloadData()
        
        return uiview
    }
    
    func measureUIView(_ path: String, proposedSize: CGSize, hosting: HostingView) -> UIView? {
        guard let uiview = hosting.queryUIView(uiviewPath(path)) as? CoreView else { return nil }
        
        uiview.transform = .identity
        uiview.frame.origin = .zero
        uiview.frame.size = proposedSize
        uiview.collectionViewLayout.invalidateLayout()
        
        return uiview
    }

}

extension CollectionView {
    
    class DCollectionView: UICollectionView, UICollectionViewDataSource {
        
        var selectedColor: UIColor? = nil
        var count: Int = 0
        var content: ((Int) -> View)? = nil
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
            
            if let sc = selectedColor {
                let sbv = UIView()
                sbv.backgroundColor = sc
                
                cell.selectedBackgroundView = sbv
            } else {
                cell.selectedBackgroundView = nil
            }
            
            cell.viewBody = content?(indexPath.item)
            
            return cell
        }
        
    }
    
    class Cell: UICollectionViewCell {
        
        var viewBody: View? = nil {
            didSet {
                if let h = contentView.subviews.first as? HostingView {
                    h.render(viewBody)
                }
            }
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            
            embedHosting()
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            embedHosting()
        }

        func embedHosting() {
            backgroundColor = .clear
            
            let v = HostingView()
            v.ignoreSafeAreaInsets = true
            v.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(v)
            
            v.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            v.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            v.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            v.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        }
        
    }
    
}
