/*
 Copyright 2016-present The Material Motion Authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import UIKit
import MaterialMotionStreams

@available(iOS 9.0, *)
public class PushBackTransitionExampleViewController: UIViewController {

  override public func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
  }

  func didTap() {
    let vc = ModalViewController()
    present(vc, animated: true)
  }
}

@available(iOS 9.0, *)
private class ModalViewController: UIViewController {

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    transitionController.transitionType = PushBackTransition.self
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .blue

    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
  }

  func didTap() {
    dismiss(animated: true)
  }
}

@available(iOS 9.0, *)
private class PushBackTransition: Transition {

  required init() {}

  func willBeginTransition(withContext ctx: TransitionContext, runtime: MotionRuntime) -> [MotionObservable<MotionState>] {
    let position = spring(back: ctx.containerView().bounds.height + ctx.fore.view.layer.bounds.height / 2,
                          fore: ctx.containerView().bounds.midY,
                          threshold: 1,
                          ctx: ctx)
    let scale = spring(back: 1, fore: 0.95, threshold: 0.005, ctx: ctx)

    runtime.add(position, to: runtime.get(ctx.fore.view.layer).positionY)
    runtime.add(scale, to: runtime.get(ctx.back.view.layer).scale)

    return [position.state.asStream(), scale.state.asStream()]
  }

  private func spring(back: CGFloat, fore: CGFloat, threshold: CGFloat, ctx: TransitionContext) -> TransitionSpring<CGFloat> {
    let spring = TransitionSpring(back: back, fore: fore, direction: ctx.direction, threshold: threshold, system: coreAnimation)
    spring.friction.value = 500
    spring.tension.value = 1000
    spring.mass.value = 3
    spring.suggestedDuration.value = 0.5
    return spring
  }
}
