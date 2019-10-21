import UIKit

class animatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting = true
    
    // MARK: методы протокола UIViewControllerAnimatedTransitioning
    
    // метод, в котором непосредственно указывается анимация перехода от одного  viewcontroller к другому
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
        guard let fromView = transitionContext.viewController(forKey: .from),
            let toView = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        let container = transitionContext.containerView
        
        let pi = CGFloat(Double.pi)
        
     
        let offScreenRotateIn = CGAffineTransform(rotationAngle: -pi/2)
        let offScreenRotateOut = CGAffineTransform(rotationAngle: pi/2)
        
        toView.view.transform = self.presenting ? offScreenRotateIn : offScreenRotateOut
        
        toView.view.layer.anchorPoint = CGPoint(x:0, y:0)
        fromView.view.layer.anchorPoint = CGPoint(x:0, y:0)
        
        toView.view.layer.position = CGPoint(x:0, y:0)
        fromView.view.layer.position = CGPoint(x:0, y:0)
        
        container.addSubview(toView.view)
        container.sendSubviewToBack(toView.view)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.49, initialSpringVelocity: 0.81, options: [], animations: { () -> Void in

            if self.presenting {
                fromView.view.transform = offScreenRotateOut
            } else {
                fromView.view.transform = offScreenRotateIn
            }
            
            toView.view.transform = .identity
            
            
        }) { (finished) -> Void in
            
            transitionContext.completeTransition(finished)
        }
    }
    
    // метод возвращает количество секунд, которые длится анимация
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
    
    // MARK: методы протокола UIViewControllerTransitioningDelegate
    
    // аниматор для презентации viewcontroller
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    // аниматор для скрытия viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
}

class animatedTransitionDismissed: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting = true
    
    // MARK: методы протокола UIViewControllerAnimatedTransitioning
    
    // метод, в котором непосредственно указывается анимация перехода от одного  viewcontroller к другому
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.viewController(forKey: .from),
            let toView = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        let container = transitionContext.containerView
        
        let pi = CGFloat(Double.pi)
        
        let offScreenRotateIn = CGAffineTransform(rotationAngle: pi/2)
        let offScreenRotateOut = CGAffineTransform(rotationAngle: -pi/2)
        
        toView.view.transform = self.presenting ? offScreenRotateIn : offScreenRotateOut
        
        toView.view.frame.size.width = fromView.view.frame.size.height
        toView.view.frame.size.height = fromView.view.frame.size.width

        toView.view.layer.anchorPoint = CGPoint(x:0, y:0)
        fromView.view.layer.anchorPoint = CGPoint(x:0, y:0)
        
        toView.view.layer.position = CGPoint(x:0, y:0)
        fromView.view.layer.position = CGPoint(x:0, y:0)
        
        container.addSubview(toView.view)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.49, initialSpringVelocity: 0.81, options: [], animations: { () -> Void in
            
            if self.presenting {
                fromView.view.transform = offScreenRotateOut
            } else {
                fromView.view.transform = offScreenRotateIn
            }
            
            toView.view.transform = .identity
            
            
        }) { (finished) -> Void in
            fromView.removeFromParent()
            transitionContext.completeTransition(finished)
        }
    }
    
    // метод возвращает количество секунд, которые длится анимация
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
    
    // MARK: методы протокола UIViewControllerTransitioningDelegate
    
    // аниматор для презентации viewcontroller
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    // аниматор для скрытия viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
}

class animatedTransitionTwo: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    // MARK: методы протокола UIViewControllerAnimatedTransitioning
    
    // метод, в котором непосредственно указывается анимация перехода от одного  viewcontroller к другому
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let fromView = transitionContext.viewController(forKey: .from),
            let toView = transitionContext.viewController(forKey: .to) else {
                return
        }

        let container = transitionContext.containerView
        container.addSubview(toView.view)
        
        toView.view.frame = CGRect(x: fromView.view.frame.width, y: 0, width: fromView.view.frame.size.width, height: fromView.view.frame.size.height)
        
        let duration = self.transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.49, initialSpringVelocity: 0.81, options: [], animations: { () -> Void in

            toView.view.frame = CGRect(x: 0, y: 0, width: fromView.view.frame.size.width, height: fromView.view.frame.size.height)
            fromView.view.frame = CGRect(x: -fromView.view.frame.width, y: 0, width: fromView.view.frame.size.width, height: fromView.view.frame.size.height)

        }) { (finished) -> Void in
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }

    // метод возвращает количество секунд, которые длится анимация
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
    
}

class animatedTransitionTwoDismissed: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: методы протокола UIViewControllerAnimatedTransitioning
    
    // метод, в котором непосредственно указывается анимация перехода от одного  viewcontroller к другому
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
       
        guard let fromView = transitionContext.viewController(forKey: .from),
            let toView = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        let container = transitionContext.containerView
        container.addSubview(toView.view)
        
        toView.view.frame = CGRect(x: -fromView.view.frame.width, y: 0, width: fromView.view.frame.size.width, height: fromView.view.frame.size.height)

        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.49, initialSpringVelocity: 0.81, options: [], animations: { () -> Void in
            
            toView.view.frame = CGRect(x: 0, y: 0, width: fromView.view.frame.size.width, height: fromView.view.frame.size.height)
            fromView.view.frame = CGRect(x: fromView.view.frame.width, y: 0, width: fromView.view.frame.size.width, height: fromView.view.frame.size.height)
            
        }) { (finished) -> Void in
            fromView.removeFromParent()
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
    
    // метод возвращает количество секунд, которые длится анимация
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
}

// MARK: - Кастомная анимация перехода UIStoryboardSegue

class CustomSegue: UIStoryboardSegue {
    override func perform() {
        guard let containerView = source.view.superview else { return }
        
        let containerViewFrame = containerView.frame
        let sourceViewTargetFrame = CGRect(x: -containerViewFrame.width,
                                           y: 0,
                                           width: source.view.frame.width,
                                           height: source.view.frame.height)
        let destinationViewTargetFrame = source.view.frame
        
        containerView.addSubview(destination.view)
        
        destination.view.frame = CGRect(x: containerViewFrame.width,
                                        y: 0,
                                        width: source.view.frame.width,
                                        height: source.view.frame.height)
        
        UIView.animate(withDuration: 2.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1.3, options: [], animations: { () -> Void in
            
            self.source.view.frame = sourceViewTargetFrame
            self.destination.view.frame = destinationViewTargetFrame
            
        }) { (finished) -> Void in
            self.source.removeFromParent()
            self.source.present(self.destination, animated: false, completion: nil)
        }
    }
}

// MARK: - Кастомная анимация перехода UIStoryboardSegue (возврат)

class CustomSegueReturn: UIStoryboardSegue {
    override func perform() {
        scale()
    }
    func scale() {
        
        guard let containerView = source.view.superview else { return }
        
        let containerViewFrame = containerView.frame
        let sourceViewTargetFrame = CGRect(x: containerViewFrame.width,
                                           y: 0,
                                           width: source.view.frame.width,
                                           height: source.view.frame.height)
        let destinationViewTargetFrame = source.view.frame

        containerView.addSubview(destination.view)
        
        destination.view.frame = CGRect(x: -containerViewFrame.width,
                                        y: 0,
                                        width: source.view.frame.width,
                                        height: source.view.frame.height)
        
        UIView.animate(withDuration: 2.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1.3, options: [], animations: { () -> Void in
            
            self.source.view.frame = sourceViewTargetFrame
            self.destination.view.frame = destinationViewTargetFrame
            
        }) { (finished) -> Void in
            self.source.removeFromParent()
            self.source.present(self.destination, animated: false, completion: nil)
        }
    }
    
}

//Интерактивное закрытие

class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self,
                                                              action: #selector(handleScreenEdgeGesture(_:)))
            recognizer.edges = [.left]
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }
    
    var hasStarted: Bool = false
    var shouldFinish: Bool = false
    
    @objc func handleScreenEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            self.hasStarted = true
            
            self.viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = translation.x / (recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            
            self.shouldFinish = progress > 0.11
            
            self.update(progress)
        case .ended:
            self.hasStarted = false
            self.shouldFinish ? self.finish() : self.cancel()
        case .cancelled:
            self.hasStarted = false
            self.cancel()
        default: return
        }
    }

    
    
}
