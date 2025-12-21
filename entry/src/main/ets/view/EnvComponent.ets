import { StatusArray } from "../common/constants/Constant";
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
      CellComponent({ title: "水体温度：", value: `${this.item.temp} ℃`, color: this.getFontColor() })
      Line().lineStyle(this.getFontColor())
      CellComponent({ title: "水位：", value: `${this.item.hum} %`, color: this.getFontColor() })
      Line().lineStyle(this.getFontColor())
      CellComponent({ title: "光照强度：", value: `${this.item.gas} lux`, color: this.getFontColor() })
      Line().lineStyle(this.getFontColor())
      CellComponent({ title: "工作模式：", value: `${this.item.mode === 'manual' ? '手动模式' : '自动模式'}`, color: this.getFontColor() })
      Line().lineStyle(this.getFontColor())
      CellComponent({ title: "补水状态：", value: `${this.item.pumpOn ? '智能加水中' : '待机'} (${this.item.waterLowLimit}-${this.item.waterHighLimit}%)`, color: this.getFontColor() })
      Line().lineStyle(this.getFontColor())
      CellComponent({ title: "温控状态：", value: `${this.getTempStatus()} (${this.item.tempMin}-${this.item.tempMax}℃)`, color: this.getFontColor() })
      Line().lineStyle(this.getFontColor())
      CellComponent({ title: "补光状态：", value: `${this.item.ledOn ? '补光中' : '待机'} (${this.item.lightLuxTarget}lux/${this.item.lightDurationHours}h)`, color: this.getFontColor() })
      Line().lineStyle(this.getFontColor())
      CellComponent({ title: "Wi-Fi：", value: this.getWifiStatus(), color: this.getFontColor() })
      Line().lineStyle(this.getFontColor())
      CellComponent({ title: "报警：", value: `${this.item.alarmMessage || StatusArray[this.item.stat]}`, color: this.getFontColor() })

    }
    .backgroundColor(this.getBackgroudColor())
    .margin({ left: 10, right: 10 })
    .padding(10)
    .borderRadius(10)
    .width('94%')
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

  private getTempStatus(): string {
    if (this.item.heaterOn) {
      return '加热中';
    }
    if (this.item.coolerOn) {
      return '散热中';
    }
    return '恒温';
  }

  private getWifiStatus(): string {
    if (!this.item.wifiConnected) {
      return '未连接';
    }
    if (this.item.wifiSsid) {
      return `已连接(${this.item.wifiSsid})`;
    }
    return '已连接';
  }
}
