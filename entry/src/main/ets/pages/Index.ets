import { window } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  // --- 核心状态变量 ---
  @State message: string = '我爱鸿蒙开发'
  @State fontSize: number = 48
  @State textColor: string = '#FFFFFF'
  @State bgColor: string = '#000000'
  @State isRoll: boolean = false
  @State speed: number = 5
  @State offsetX: number = 0
  @State scrollDir: 'left' | 'right' = 'left'
  @State vAlign: 'top' | 'center' | 'bottom' = 'center'

  // 样式状态
  @State isBold: boolean = true
  @State isItalic: boolean = false
  @State isStroke: boolean = false
  @State isBlink: boolean = false

  // 全屏状态 (添加 Watch 监听)
  @State isFullScreen: boolean = false
  private windowStage: window.Window | null = null;

  // 1. 获取窗口实例 (页面加载时执行)
  aboutToAppear() {
    try {
      window.getLastWindow(getContext(this)).then((win) => {
        this.windowStage = win;
      }).catch((err: Error) => {
        console.error('获取窗口失败:', err.message);
      });
    } catch (e) {
      console.error('aboutToAppear error:', e);
    }
  }

  // 2. 监听全屏变化，控制屏幕常亮
  // 注意：这里不使用 @Watch，而是直接在点击事件中控制，或者使用 onChange 回调
  // 为了保持代码简洁，我在“全屏模式”按钮的点击事件中直接加入控制逻辑（见下方 build 方法）

  build() {
    Column({ space: 12 }) {
      // 标题
      Text('手持弹幕 Pro')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 10, bottom: 10 })

      // 1. 弹幕内容
      TextInput({ placeholder: '输入弹幕内容', text: this.message })
        .onChange(val => this.message = val)
        .width('90%')
        .height(48)

      // 2. 字号
      Row({ space: 10 }) {
        Text(`字号：${this.fontSize}`).fontSize(16)
        Slider({ min: 20, max: 100, value: this.fontSize })
          .onChange(val => this.fontSize = val)
          .layoutWeight(1)
      }.width('90%')

      // 3. 文字样式
      Text('文字样式：').fontSize(16).width('90%')
      Row({ space: 6 }) {
        Button(this.isBold ? '粗体✓' : '粗体')
          .onClick(() => this.isBold = !this.isBold)
          .fontSize(12).height(32)
        Button(this.isItalic ? '斜体✓' : '斜体')
          .onClick(() => this.isItalic = !this.isItalic)
          .fontSize(12).height(32)
        Button(this.isStroke ? '描边✓' : '描边')
          .onClick(() => this.isStroke = !this.isStroke)
          .fontSize(12).height(32)
        Button(this.isBlink ? '闪烁✓' : '闪烁')
          .onClick(() => this.isBlink = !this.isBlink)
          .fontSize(12).height(32)
      }.width('90%')

      // 4. 颜色选择 (简化展示)
      Row({ space: 6 }) {
        Button(' ').backgroundColor('#fff').width(30).height(30).borderRadius(15).onClick(() => this.textColor = '#fff')
        Button(' ').backgroundColor('#f44').width(30).height(30).borderRadius(15).onClick(() => this.textColor = '#f44')
        Button(' ').backgroundColor('#44f').width(30).height(30).borderRadius(15).onClick(() => this.textColor = '#44f')
        Button(' ').backgroundColor('#ff0').width(30).height(30).borderRadius(15).onClick(() => this.textColor = '#ff0')
      }.width('90%').justifyContent(FlexAlign.Start)

      // 5. 速度与方向
      Row({ space: 10 }) {
        Text(`速度：${this.speed}`).fontSize(16)
        Slider({ min: 1, max: 20, value: this.speed })
          .onChange(val => this.speed = val)
          .layoutWeight(1)
      }.width('90%')

      Row({ space: 10 }) {
        Button(this.scrollDir === 'left' ? '← 向左滚' : '向右滚 →')
          .onClick(() => this.scrollDir = this.scrollDir === 'left' ? 'right' : 'left')
          .layoutWeight(1)
        Button(`位置：${this.vAlign}`)
          .onClick(() => {
            if (this.vAlign === 'top') this.vAlign = 'center'
            else if (this.vAlign === 'center') this.vAlign = 'bottom'
            else this.vAlign = 'top'
          })
          .layoutWeight(1)
      }.width('90%')

      // 6. 控制按钮区
      Row({ space: 10 }) {
        Button(this.isRoll ? '⏸ 停止' : '▶ 开始')
          .width('43%')
          .backgroundColor('#007dff')
          .onClick(() => {
            this.isRoll = !this.isRoll
            if (this.isRoll) this.startScrollAnimation()
            else this.offsetX = 0 // 停止时重置位置或保持当前位置，这里简单重置
          })

        // 全屏按钮 - 在这里直接控制屏幕常亮
        Button(this.isFullScreen ? '退出全屏' : '全屏模式')
          .width('43%')
          .backgroundColor('#ff6600')
          .onClick(() => {
            this.isFullScreen = !this.isFullScreen
            this.setKeepScreenOn(this.isFullScreen)
          })
      }.width('90%')

      Button('🔄 重置')
        .width('90%')
        .backgroundColor('#333')
        .onClick(() => this.resetAll())

      // 7. 弹幕展示区域
      this.buildDisplayArea()
    }
    .width('100%')
    .padding(10)
    .backgroundColor('#f5f5f5')
  }

  // --- 辅助功能函数 ---

  // 设置屏幕常亮
  setKeepScreenOn(isOn: boolean) {
    if (this.windowStage) {
      try {
        this.windowStage.setWindowKeepScreenOn(isOn);
      } catch (e) {
        console.error('设置屏幕常亮失败', e);
      }
    }
  }

  @Builder
  buildDisplayArea() {
    Stack({ alignContent: this.getAlignment() }) {
      Text(this.message)
        .fontSize(this.fontSize)
        .fontColor(this.textColor)
        .fontWeight(this.isBold ? FontWeight.Bold : FontWeight.Normal)
        .fontStyle(this.isItalic ? FontStyle.Italic : FontStyle.Normal)
        // 描边效果模拟
        .textShadow(this.isStroke ? { radius: 2, color: '#000', offsetX: 1, offsetY: 1 } : undefined)
        // 闪烁动画
        .opacity(this.isBlink && this.isRoll ? 0.3 : 1)
        .animation(this.isBlink && this.isRoll ? { duration: 500, iterations: -1, playMode: PlayMode.Alternate } : undefined)
        // 滚动位移
        .translate({ x: this.offsetX })
    }
    .width(this.isFullScreen ? '100%' : '95%')
    .height(this.isFullScreen ? '100%' : 220)
    .backgroundColor(this.bgColor)
    .borderRadius(this.isFullScreen ? 0 : 16)
    // 全屏模式下点击退出
    .onClick(() => {
      if (this.isFullScreen) {
        this.isFullScreen = false;
        this.isRoll = false;
        this.setKeepScreenOn(false);
      }
    })
  }

  getAlignment(): Alignment {
    if (this.vAlign === 'top') return Alignment.Top
    if (this.vAlign === 'bottom') return Alignment.Bottom
    return Alignment.Center
  }

  startScrollAnimation() {
    // 简单的滚动逻辑
    const screenWidth = 1000; // 估算宽度，实际开发可用 px2vp 获取
    const startX = this.scrollDir === 'left' ? screenWidth : -screenWidth;
    const endX = this.scrollDir === 'left' ? -screenWidth : screenWidth;

    this.offsetX = startX;

    animateTo({
      duration: 10000 / this.speed, // 速度越快，时间越短
      iterations: -1,
      playMode: PlayMode.Normal,
      curve: Curve.Linear
    }, () => {
      this.offsetX = endX;
    });
  }

  resetAll() {
    this.message = '我爱鸿蒙开发'
    this.fontSize = 48
    this.textColor = '#FFFFFF'
    this.bgColor = '#000000'
    this.isRoll = false
    this.speed = 5
    this.offsetX = 0
    this.isFullScreen = false
    this.setKeepScreenOn(false); // 重置时关闭常亮
    this.scrollDir = 'left'
    this.vAlign = 'center'
    this.isBold = true
    this.isItalic = false
    this.isStroke = false
    this.isBlink = false
  }
}