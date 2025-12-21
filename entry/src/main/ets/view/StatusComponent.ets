import AquaticTankViewModel from "../viewmodel/AquaticTankViewModel";
import {
  AlarmStatusArray,
  WifiStatusArray,
  DeviceStatusArray
} from "../common/constants/Constant";

@Component
export struct StatusComponent {
  @Prop
  item: AquaticTankViewModel;

  build() {
    Column() {
      // 标题栏
      Row() {
        Text("实时状态")
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
        Blank()
        Row() {
          Circle()
            .width(8)
            .height(8)
            .fill(this.item.wifiStatus === 1 ? '#4CAF50' : '#FF5722')
          Text(WifiStatusArray[this.item.wifiStatus])
            .fontSize(12)
            .fontColor(this.item.wifiStatus === 1 ? '#4CAF50' : '#FF5722')
            .margin({ left: 4 })
        }
      }
      .width('100%')
      .margin({ bottom: 12 })

      // 水位指示
      Row() {
        Image($r('app.media.water_level'))
          .width(24)
          .height(24)
        Column() {
          Row() {
            Text("水位")
              .fontSize(14)
              .fontColor('#666666')
            Blank()
            Text(`${this.item.waterLevel}%`)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor(this.getWaterLevelColor())
          }
          .width('100%')

          Progress({ value: this.item.waterLevel, total: 100, type: ProgressType.Linear })
            .width('100%')
            .height(8)
            .color(this.getWaterLevelColor())
            .backgroundColor('#E0E0E0')
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .margin({ left: 8 })
      }
      .width('100%')
      .padding(8)
      .backgroundColor('#F5F5F5')
      .borderRadius(8)
      .margin({ bottom: 8 })

      // 水温指示
      Row() {
        Image($r('app.media.temperature'))
          .width(24)
          .height(24)
        Column() {
          Row() {
            Text("水温")
              .fontSize(14)
              .fontColor('#666666')
            Blank()
            Text(`${this.item.waterTemp}°C`)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor(this.getWaterTempColor())
          }
          .width('100%')

          Row() {
            Text(`${this.item.waterTempMin}°C`)
              .fontSize(10)
              .fontColor('#999999')
            Progress({ value: this.getTempProgress(), total: 100, type: ProgressType.Linear })
              .layoutWeight(1)
              .height(8)
              .color(this.getWaterTempColor())
              .backgroundColor('#E0E0E0')
              .margin({ left: 4, right: 4 })
            Text(`${this.item.waterTempMax}°C`)
              .fontSize(10)
              .fontColor('#999999')
          }
          .width('100%')
          .margin({ top: 4 })
        }
        .layoutWeight(1)
        .margin({ left: 8 })
      }
      .width('100%')
      .padding(8)
      .backgroundColor('#F5F5F5')
      .borderRadius(8)
      .margin({ bottom: 8 })

      // 光照强度
      Row() {
        Image($r('app.media.light'))
          .width(24)
          .height(24)
        Column() {
          Row() {
            Text("光照")
              .fontSize(14)
              .fontColor('#666666')
            Blank()
            Text(`${this.item.lightIntensity} lux`)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor(this.getLightColor())
          }
          .width('100%')

          Row() {
            Text(`阈值: ${this.item.lightThreshold} lux`)
              .fontSize(10)
              .fontColor('#999999')
            Blank()
            Text(this.item.lightIntensity < this.item.lightThreshold ? "需补光" : "充足")
              .fontSize(10)
              .fontColor(this.item.lightIntensity < this.item.lightThreshold ? '#FF9800' : '#4CAF50')
          }
          .width('100%')
          .margin({ top: 4 })
        }
        .layoutWeight(1)
        .margin({ left: 8 })
      }
      .width('100%')
      .padding(8)
      .backgroundColor('#F5F5F5')
      .borderRadius(8)
      .margin({ bottom: 8 })

      // 设备状态栏
      Row() {
        this.DeviceIndicator("补水泵", this.item.pumpStatus, '#2196F3')
        this.DeviceIndicator("加热器", this.item.heaterStatus, '#FF5722')
        this.DeviceIndicator("风扇", this.item.fanStatus, '#00BCD4')
        this.DeviceIndicator("LED灯", this.item.ledStatus, '#FFEB3B')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      // 报警状态
      if (this.item.alarmStatus > 0) {
        Row() {
          Image($r('app.media.alarm'))
            .width(20)
            .height(20)
          Text(this.item.alarmMessage || AlarmStatusArray[this.item.alarmStatus])
            .fontSize(14)
            .fontColor('#FF5722')
            .margin({ left: 8 })
        }
        .width('100%')
        .padding(8)
        .backgroundColor('#FFEBEE')
        .borderRadius(8)
        .margin({ top: 8 })
      }
    }
    .padding(12)
    .width('94%')
    .borderRadius(12)
    .backgroundColor(Color.White)
    .margin({ left: '3%', right: '3%' })
  }

  @Builder
  DeviceIndicator(name: string, status: number, activeColor: string) {
    Column() {
      Circle()
        .width(12)
        .height(12)
        .fill(status === 1 ? activeColor : '#BDBDBD')
      Text(name)
        .fontSize(10)
        .fontColor('#666666')
        .margin({ top: 4 })
      Text(DeviceStatusArray[status])
        .fontSize(10)
        .fontColor(status === 1 ? activeColor : '#999999')
    }
    .alignItems(HorizontalAlign.Center)
  }

  getWaterLevelColor(): string {
    if (this.item.waterLevel < this.item.waterLevelMin) {
      return '#FF5722';
    } else if (this.item.waterLevel > this.item.waterLevelMax) {
      return '#FF9800';
    }
    return '#4CAF50';
  }

  getWaterTempColor(): string {
    if (this.item.waterTemp < this.item.waterTempMin) {
      return '#2196F3';
    } else if (this.item.waterTemp > this.item.waterTempMax) {
      return '#FF5722';
    }
    return '#4CAF50';
  }

  getTempProgress(): number {
    const range = this.item.waterTempMax - this.item.waterTempMin;
    if (range <= 0) return 50;
    const progress = ((this.item.waterTemp - this.item.waterTempMin + 5) / (range + 10)) * 100;
    return Math.max(0, Math.min(100, progress));
  }

  getLightColor(): string {
    return this.item.lightIntensity < this.item.lightThreshold ? '#FF9800' : '#4CAF50';
  }
}
