import UIKit

class ViewController: UIViewController {
    
    var showed: Bool = false

    func MyButton(_ text: String, action: Selector, secondary: Bool = false) -> View {
        Button(.custom) {
            $0.setTitle(text, for: .normal)
            $0.setTitleColor(secondary ? .systemPink : .white, for: .normal)
            $0.setTitleColor(.black, for: .highlighted)
            
            $0.titleLabel?.font = .boldSystemFont(ofSize: 17)

            if secondary {
                $0.setBackgroundImage(UIColor.white.pixelImage, for: .normal)
                $0.setBackgroundImage(UIColor(white: 0.9, alpha: 1).pixelImage, for: .highlighted)
            } else {
                $0.setBackgroundImage(UIColor.systemPink.pixelImage, for: .normal)
                $0.setBackgroundImage(UIColor(white: 0.9, alpha: 1).pixelImage, for: .highlighted)
            }
        }
        .target(self, action: action, event: .touchUpInside)
        .resizable()
        .frame(width: 120, height: 50)
        .border(width: secondary ? 1 : 0, color: .systemPink)
        .cornerRadius()
        .clipped()
    }
    
    func MovieCard(_ text: String, detailText: String, image: String) -> View {
        Image(named: image)
            .resizable()
            .scaledToFill()
            .overlay(
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(text)
                            .font(style: .headline)
                        Text(detailText)
                            .foregroundColor(UIColor(white: 0, alpha: 0.7))
                    }
                    Spacer()
                }
                .padding(16)
                .background(Material(.extraLight)), alignment: .bottom)
        .cornerRadius()
        .clipped()
        .frame(width: 250, height: 250)
        .padding(.zero)
        .shadow(opacity: 0.2)
    }
    
    var viewBody: View {
        VStack(spacing: 50) {
            Text("Movies")
                .font(style: .title1)
            ZStack {
                MovieCard("Minions: The Rise of Gru", detailText: "M/6 | Animation", image: "minions-2")
                    .offset(x: showed ? -20 : 0, y: showed ? 10 : 0)
                    .rotationEffect(angle: showed ? -10 : 0)
                MovieCard("Despicable Me 3", detailText: "M/6 | 1h 29min | Animation", image: "minions-3")
                    .offset(x: showed ? 20 : 0, y: showed ? 10 : 0)
                    .rotationEffect(angle: showed ? 10 : 0)
                MovieCard("Minions", detailText: "M/6 | 1h 31min | Animation", image: "minions-1")
            }
            HStack(spacing: 10) {
                MyButton("BUY", action: #selector(self.buttonAction), secondary: false)
                MyButton("TRAILER", action: #selector(self.buttonAction), secondary: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showed = false
        
        let hv = view as! HostingView
        hv.render(viewBody)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showed = true

        let hv = view as! HostingView
        hv.animatedRender(viewBody, animation: .spring())
    }
    
    @objc func buttonAction() {
        let alert = UIAlertController(title: "Hello Minions World!", message: "", preferredStyle: .alert)
        alert.view.tintColor = .systemPink
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }

}
