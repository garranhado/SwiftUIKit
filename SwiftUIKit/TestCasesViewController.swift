import UIKit

class TestCasesViewController: UIViewController {
    
    var state: Int = 0
    
    var collectionViewLayout: UICollectionViewLayout {
        let layout = CustomCollectionViewFlowLayout()
        
        layout.multipleColumn = .center
        layout.margin = CGSize(width: 0, height: 16)
        layout.spacing = CGSize(width: 16, height: 16)
        layout.preferredItemSize = CGSize(width: 100, height: 100)
        
        return layout
    }
    
    var viewBody1: View {
        Color(.systemPink)
            //.opacity(0.5)
            //.frame(width: 320, height: 240)
            //.padding()
            //.aspectRatio(16.0 / 9.0)
            //.edgesIgnoringSafeArea()
            //.offset(x: 100, y: 100)
    }
    
    var viewBody2: View {
        Text("Hello World!")
            .foregroundColor(.white)
            .backgroundColor(.systemPink)
            .padding()
            .backgroundColor(.systemBlue)
            .padding()
            .backgroundColor(.systemGreen)
            //.frame(width: 320, height: 240)
            //.edgesIgnoringSafeArea()
            //.font(forTextStyle: .headline)
    }
    
    var viewBody3: View {
        //Image(url: URL(string: "http://lorempixel.com/400/200/")!, cornerRadius: .rounded(12))
        Image(named: "minions-1")
            .backgroundColor(.green)
            .resizable()
            //.scaledToFit()
            .scaledToFill()
            .cornerRadius()
            .clipped()
            .padding(.zero)
            .shadow()
            //.rotationEffect(angle: 30)
            .opacity(state == 1 ? 1 : 0)
            //.backgroundColor(.systemPink)
            .frame(width: 320, height: 240)
            .gesture(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
            //.border(width: 3, color: .systemPink)
            .scaleEffect(x: state == 1 ? 1 : 0.001, y: state == 1 ? 1 : 0.001)
            .shouldRasterize()
            //.backgroundColor(.systemPink)
            //.edgesIgnoringSafeArea()
    }
    
    var viewBody4: View {
        Button(.custom) {
            $0.setTitle("Click Me!", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 19)
            
            $0.setBackgroundImage(UIColor.systemPink.pixelImage, for: .normal)
            $0.setBackgroundImage(UIColor.systemPurple.pixelImage, for: .highlighted)
        }
        .target(self, action: #selector(self.buttonAction), event: .touchUpInside)
        .resizable()
        .frame(width: 150, height: 50)
        //.padding(horizontal: 16, vertical: 8)
        //.backgroundColor(.systemPink)
        .cornerRadius()
        .clipped()
    }
    
    var viewBody5: View {
        TableView { v in
            v.register(TableView.Cell.self, forCellReuseIdentifier: "cell")
            v.dataSource = self
        }
        .scrollInsets()
        .edgesIgnoringSafeArea()
    }
    
    var viewBody6: View {
        ZStack {
            Color(.systemPink)
            Image(named: "minions-1")
            Text("Hello World!")
                .padding()
                .backgroundColor(.white)
        }
    }
    
    var viewBody7: View {
        VStack {
            Text("Hello World!")
            Divider()
            Spacer()
            Color(.systemPink)
                .frame(maxWidth: 200, maxHeight: 200)
            Spacer()
            Image(named: "minions-1")
            Text("Hello World Again!")
        }
    }

    var viewBody8: View {
        HStack {
            Color(.systemPink)
                .frame(width: 100, height: 200)
//            Text("Hello World!")
//            Divider()
//            Spacer()
//            Color(.systemPink)
//                .frame(width: 100, height: 200)
            Text("#1 Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                .layoutPriority(1)
            Text("#2 Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
        }
    }
    
    var viewBody9: View {
        VStack {
            ForEach(0..<15) { i in
                Text("Text #\(i)")
                    .hidden(i == 7)
            }
        }
    }
    
    var viewBody10: View {
        ScrollView {
            VStack {
                ForEach(0..<50) { i in
                    //Color(.systemPink)
                    //    .frame(height: 44)
                    Text("Text #\(i)")
                }
            }
            .backgroundColor(.systemGray6)
        }
        .backgroundColor(.systemGray5)
        .scrollInsets(insetReference: .safeArea(top: true, leading: false, bottom: true, trailing: false))
        .edgesIgnoringSafeArea()
    }
    
    var viewBody11: View {
        Gradient(startColor: .systemPink, endColor: .systemPurple)
    }
    
    var viewBody12: View {
        TableView({ v in
            //v.separatorInset = .zero
        }, selectedColor: .systemPink, count: 50) { i in
//            Color(.systemPink)
//                .frame(height: 50)
            Text("Cell \(i)")
                .foregroundColor(.black, highlightedColor: .white)
                .padding()
        }
        .scrollInsets(insetReference: .safeArea(top: true, leading: false, bottom: true, trailing: false))
        .edgesIgnoringSafeArea()
    }
    
    var viewBody13: View {
        CollectionView({ _ in }, layout: collectionViewLayout, selectedColor: .systemTeal, count: 100) { i in
            Text("\(i)")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .backgroundColor(.systemPink)
                .cornerRadius()
        }
        .scrollInsets(insetReference: .safeArea(top: true, leading: false, bottom: true, trailing: false))
        .edgesIgnoringSafeArea()
//        .backgroundColor(.systemGray5)
    }
    
    var viewBody14: View {
        Image(named: "minions-1")
            .overlay(
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Material(.extraLight)), alignment: .bottom)
            .cornerRadius()
            .clipped()
    }
    
    var viewBody15: View {
        SegmentedControl {
            $0.insertSegment(withTitle: "World #1", at: 0, animated: false)
            $0.insertSegment(withTitle: "World #2", at: 1, animated: false)
            $0.insertSegment(withTitle: "World #3", at: 2, animated: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hv = view as! HostingView
        hv.render(viewBody8)
    }
    
    @objc func buttonAction() {
        let hv = view as! HostingView
        
        state = 0
        hv.render(viewBody3)
        
        state = 1
        hv.animatedRender(viewBody3, animation: .spring())
    }
    
    @objc func tapAction() {
        let hv = view as! HostingView
        
        state = 0
        hv.animatedRender(viewBody3, animation: .easeIn()) {
            hv.render(self.viewBody4)
        }
    }

}

extension TestCasesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableView.Cell
        
        cell.viewBody = Text("Cell \(indexPath.row)")
                            .padding()
        
        return cell
    }
    
}
