import UIKit

struct TableView: View {
    
    typealias CoreView = DTableView
    
    let update: (CoreView) -> Void
    
    let selectedColor: UIColor?
    let count: Int
    let content: ((Int) -> View)?
    
    init(_ update: @escaping (CoreView) -> Void) {
        self.update = update
        
        self.selectedColor = nil
        self.count = 0
        self.content = nil
    }
    
    init(_ update: @escaping (CoreView) -> Void, selectedColor: UIColor? = nil, count: Int = 0, content: @escaping (Int) -> View) {
        self.update = update
        
        self.selectedColor = selectedColor
        self.count = count
        self.content = content
    }
    
}

extension TableView {

    func makeUIView(_ path: String, hosting: HostingView) -> UIView? {
        let uiview: CoreView
        let path = uiviewPath(path)
        
        if let v = hosting.reuseUIView(path) {
            uiview = v as! CoreView
        } else {
            uiview = CoreView()
            uiview.backgroundColor = .clear
            uiview.contentInsetAdjustmentBehavior = .never
            uiview.insetsContentViewsToSafeArea = false

            hosting.cacheUIView(uiview, path: path)
            
            DispatchQueue.main.async {
                uiview.contentOffset = CGPoint(x: 0.0, y: -uiview.contentInset.top)
            }
        }
        
        if let c = content {
            uiview.selectedColor = selectedColor
            uiview.count = count
            uiview.content = c
            
            uiview.register(Cell.self, forCellReuseIdentifier: "cell")
            uiview.dataSource = uiview
            
        } else {
            uiview.register(nil as UINib?, forCellReuseIdentifier: "cell")
        }
        
        update(uiview)
        
        uiview.reloadData()
        
        return uiview
    }
    
}

extension TableView {
    
    class DTableView: UITableView, UITableViewDataSource {
        
        var selectedColor: UIColor? = nil
        var count: Int = 0
        var content: ((Int) -> View)? = nil
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
            
            if let sc = selectedColor {
                let sbv = UIView()
                sbv.backgroundColor = sc
                
                cell.selectedBackgroundView = sbv
            } else {
                cell.selectedBackgroundView = nil
            }
            
            cell.viewBody = content?(indexPath.row)
            
            return cell
        }
        
    }
    
    class Cell: UITableViewCell {
        
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
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
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
