import { StatusArray, AlarmTypeArray, ModeArray } from "../common/constants/Constant";
import EnvironmentViewModel from "../viewmodel/EnvironmentViewModel";
import { CellComponent } from "./CellComponent";

@Extend(Line)
function lineStyle(backgroundColor: Color) {
  .width('94%')
  .height(1)
  .backgroundColor(backgroundColor)
  .margin({ top: 4, bottom: 4 })
}

@Component
export struct EnvComponent {
  @Prop
  item: EnvironmentViewModel;

  build() {
    Column() {
      // 标题栏显示当前模式
      Row() {
        Text('水生植物养殖缸监控')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.getFontColor())
        Text(ModeArray[this.item.mode])
          .fontSize(14)
          .fontColor(this.getFontColor())
          .padding({ left: 8, right: 8, top: 2, bottom: 2 })
          .borderRadius(10)
          .backgroundColor(this.item.mode === 0 ? '#2E7D32' : '#1565C0')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ bottom: 8 })

      CellComponent({ title: "💧 水位：", value: `${this.item.waterLevel} %`, color: this.getFontColor() })
      Line().lineStyle(this.getFontColor())
      CellComponent({ title: "🌡️ 水温：", value: `${this.item.temp} ℃`, color: this.getFontColor() })
      Line().lineStyle(this.getFontColor())
      CellComponent({ title: "☀️ 光照强度：", value: `${this.item.light} lux`, color: this.getFontColor() })
      Line().lineStyle(this.getFontColor())
      CellComponent({ title: "⚠️ 报警状态：", value: `${AlarmTypeArray[this.item.alarmType]}`, color: this.getFontColor() })
      Line().lineStyle(this.getFontColor())
      CellComponent({ title: "🔒 安全级别：", value: `${StatusArray[this.item.stat]}`, color: this.getFontColor() })

      // 设备状态指示
      Row() {
        this.DeviceIndicator('水泵', this.item.pumpOn, '#2196F3')
        this.DeviceIndicator('加热', this.item.heaterOn, '#FF5722')
        this.DeviceIndicator('散热', this.item.coolerOn, '#00BCD4')
        this.DeviceIndicator('LED灯', this.item.ledOn, '#FFEB3B')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)
      .margin({ top: 10 })
    }
    .backgroundColor(this.getBackgroudColor())
    .margin({ left: 10, right: 10 })
    .padding(10)
    .borderRadius(10)
    .width('94%')
  }

  @Builder
  DeviceIndicator(name: string, isOn: boolean, activeColor: string) {
    Column() {
      Circle()
        .width(12)
        .height(12)
        .fill(isOn ? activeColor : '#9E9E9E')
      Text(name)
        .fontSize(10)
        .fontColor(this.getFontColor())
        .margin({ top: 2 })
    }
  }

  getBackgroudColor(): Color {
    switch (this.item.stat) {
      case 0:
        return Color.Green;
      case 1:
        return Color.Yellow;
      case 2:
        return Color.Red;
      default:
        return Color.Gray;
    }
  }

  getFontColor(): Color {
    switch (this.item.stat) {
      case 0:
        return Color.White;
      case 1:
        return Color.Red;
      case 2:
        return Color.White;
      default:
        return Color.White;
    }
  }
}