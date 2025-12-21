import AquaticTankViewModel from "../viewmodel/AquaticTankViewModel";
import { ControlModeArray } from "../common/constants/Constant";
import { promptAction } from '@kit.ArkUI';

@Component
export struct ControlComponent {
  @Link
  item: AquaticTankViewModel;

  @Prop
  onControlChange: (controlType: string, value: number) => void = () => {};

  build() {
    Column() {
      // 标题和模式切换
      Row() {
        Text("设备控制")
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
        Blank()
        Row() {
          Text(ControlModeArray[this.item.controlMode])
            .fontSize(14)
            .fontColor(this.item.controlMode === 0 ? '#4CAF50' : '#2196F3')
          Toggle({ type: ToggleType.Switch, isOn: this.item.controlMode === 1 })
            .width(50)
            .height(26)
            .selectedColor('#2196F3')
            .switchPointColor(Color.White)
            .margin({ left: 8 })
            .onChange((isOn: boolean) => {
              this.item.controlMode = isOn ? 1 : 0;
              this.onControlChange('mode', this.item.controlMode);
              promptAction.showToast({
                message: `已切换为${ControlModeArray[this.item.controlMode]}`,
                duration: 1500
              });
            })
        }
      }
      .width('100%')
      .margin({ bottom: 16 })

      // 控制按钮区域
      Column({ space: 12 }) {
        // 补水控制
        Row() {
          Row() {
            Image($r('app.media.pump'))
              .width(28)
              .height(28)
            Column() {
              Text("补水泵")
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
              Text(this.item.pumpStatus === 1 ? "运行中" : "已停止")
                .fontSize(12)
                .fontColor(this.item.pumpStatus === 1 ? '#2196F3' : '#999999')
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ left: 12 })
          }

          Blank()

          Button(this.item.pumpStatus === 1 ? "停止" : "启动")
            .fontSize(14)
            .fontColor(Color.White)
            .backgroundColor(this.item.pumpStatus === 1 ? '#FF5722' : '#2196F3')
            .height(32)
            .width(70)
            .borderRadius(16)
            .enabled(this.item.controlMode === 1)
            .opacity(this.item.controlMode === 1 ? 1 : 0.5)
            .onClick(() => {
              this.toggleDevice('pump');
            })
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#E3F2FD')
        .borderRadius(10)

        // 加热器控制
        Row() {
          Row() {
            Image($r('app.media.heater'))
              .width(28)
              .height(28)
            Column() {
              Text("加热器")
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
              Text(this.item.heaterStatus === 1 ? "加热中" : "已关闭")
                .fontSize(12)
                .fontColor(this.item.heaterStatus === 1 ? '#FF5722' : '#999999')
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ left: 12 })
          }

          Blank()

          Button(this.item.heaterStatus === 1 ? "关闭" : "开启")
            .fontSize(14)
            .fontColor(Color.White)
            .backgroundColor(this.item.heaterStatus === 1 ? '#757575' : '#FF5722')
            .height(32)
            .width(70)
            .borderRadius(16)
            .enabled(this.item.controlMode === 1)
            .opacity(this.item.controlMode === 1 ? 1 : 0.5)
            .onClick(() => {
              this.toggleDevice('heater');
            })
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FBE9E7')
        .borderRadius(10)

        // 散热风扇控制
        Row() {
          Row() {
            Image($r('app.media.fan'))
              .width(28)
              .height(28)
            Column() {
              Text("散热风扇")
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
              Text(this.item.fanStatus === 1 ? "散热中" : "已关闭")
                .fontSize(12)
                .fontColor(this.item.fanStatus === 1 ? '#00BCD4' : '#999999')
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ left: 12 })
          }

          Blank()

          Button(this.item.fanStatus === 1 ? "关闭" : "开启")
            .fontSize(14)
            .fontColor(Color.White)
            .backgroundColor(this.item.fanStatus === 1 ? '#757575' : '#00BCD4')
            .height(32)
            .width(70)
            .borderRadius(16)
            .enabled(this.item.controlMode === 1)
            .opacity(this.item.controlMode === 1 ? 1 : 0.5)
            .onClick(() => {
              this.toggleDevice('fan');
            })
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#E0F7FA')
        .borderRadius(10)

        // LED灯控制
        Row() {
          Row() {
            Image($r('app.media.led'))
              .width(28)
              .height(28)
            Column() {
              Text("LED补光灯")
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
              Text(this.item.ledStatus === 1 ? "补光中" : "已关闭")
                .fontSize(12)
                .fontColor(this.item.ledStatus === 1 ? '#FFC107' : '#999999')
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ left: 12 })
          }

          Blank()

          Button(this.item.ledStatus === 1 ? "关闭" : "开启")
            .fontSize(14)
            .fontColor(this.item.ledStatus === 1 ? '#333333' : Color.White)
            .backgroundColor(this.item.ledStatus === 1 ? '#757575' : '#FFC107')
            .height(32)
            .width(70)
            .borderRadius(16)
            .enabled(this.item.controlMode === 1)
            .opacity(this.item.controlMode === 1 ? 1 : 0.5)
            .onClick(() => {
              this.toggleDevice('led');
            })
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFF8E1')
        .borderRadius(10)
      }

      // 手动模式提示
      if (this.item.controlMode === 0) {
        Text("当前为自动模式，设备由系统自动控制")
          .fontSize(12)
          .fontColor('#999999')
          .margin({ top: 12 })
      }
    }
    .padding(12)
    .width('94%')
    .borderRadius(12)
    .backgroundColor(Color.White)
    .margin({ left: '3%', right: '3%' })
  }

  toggleDevice(deviceType: string) {
    switch (deviceType) {
      case 'pump':
        this.item.pumpStatus = this.item.pumpStatus === 1 ? 0 : 1;
        this.onControlChange('pump', this.item.pumpStatus);
        break;
      case 'heater':
        this.item.heaterStatus = this.item.heaterStatus === 1 ? 0 : 1;
        this.onControlChange('heater', this.item.heaterStatus);
        break;
      case 'fan':
        this.item.fanStatus = this.item.fanStatus === 1 ? 0 : 1;
        this.onControlChange('fan', this.item.fanStatus);
        break;
      case 'led':
        this.item.ledStatus = this.item.ledStatus === 1 ? 0 : 1;
        this.onControlChange('led', this.item.ledStatus);
        break;
    }
  }
}
