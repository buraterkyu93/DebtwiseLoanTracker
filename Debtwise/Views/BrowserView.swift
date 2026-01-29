import SwiftUI
import WebKit

struct BrowserView: View {
    let destination: String
    
    var body: some View {
        BrowserContainerView(destination: destination)
            .ignoresSafeArea()
            .statusBarHidden()
            .onAppear {
                AppDelegate.orientationLock = .all
                rotateToAllOrientations()
            }
            .onDisappear {
                AppDelegate.orientationLock = .portrait
                rotateToPortrait()
            }
    }
    
    private func rotateToAllOrientations() {
        if #available(iOS 16.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .all))
            
            for window in windowScene.windows {
                window.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            }
        } else {
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
    
    private func rotateToPortrait() {
        if #available(iOS 16.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
            
            for window in windowScene.windows {
                window.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            }
        } else {
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}

struct BrowserContainerView: UIViewControllerRepresentable {
    let destination: String
    
    func makeUIViewController(context: Context) -> BrowserViewController {
        let controller = BrowserViewController()
        controller.destination = destination
        return controller
    }
    
    func updateUIViewController(_ uiViewController: BrowserViewController, context: Context) {}
}

class BrowserViewController: UIViewController, WKNavigationDelegate {
    var destination: String = ""
    private var contentView: WKWebView!
    private var loadingView: UIView!
    private var activityIndicator: UIActivityIndicatorView!
    private var isInitialLoad = true
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupLoadingView()
        setupContentView()
        loadDestination()
    }
    
    private func setupLoadingView() {
        loadingView = UIView()
        loadingView.backgroundColor = .black
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    private func setupContentView() {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()
        
        contentView = WKWebView(frame: .zero, configuration: configuration)
        contentView.navigationDelegate = self
        contentView.allowsBackForwardNavigationGestures = true
        contentView.scrollView.contentInsetAdjustmentBehavior = .never
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.isOpaque = false
        contentView.backgroundColor = .black
        
        view.insertSubview(contentView, at: 0)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func loadDestination() {
        guard let link = URL(string: destination) else { return }
        var request = URLRequest(url: link)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        contentView.load(request)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if isInitialLoad {
            isInitialLoad = false
            UIView.animate(withDuration: 0.3) {
                self.loadingView.alpha = 0
            } completion: { _ in
                self.loadingView.isHidden = true
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if isInitialLoad {
            isInitialLoad = false
            UIView.animate(withDuration: 0.3) {
                self.loadingView.alpha = 0
            } completion: { _ in
                self.loadingView.isHidden = true
            }
        }
    }
}
