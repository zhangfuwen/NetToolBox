import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit'
import { window } from '@kit.ArkUI'

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // Ability 创建时调用
  }

  onDestroy(): void {
    // Ability 销毁时调用
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // 窗口创建时调用
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        console.error('Failed to load content')
        return
      }
      console.info('Succeeded in loading content')
    })
  }

  onWindowStageDestroy(): void {
    // 窗口销毁时调用
  }

  onForeground(): void {
    // 应用进入前台时调用
  }

  onBackground(): void {
    // 应用进入后台时调用
  }
}
