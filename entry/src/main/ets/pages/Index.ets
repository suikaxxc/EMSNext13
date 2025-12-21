import { AIComponent } from '../view/AIComponent';
import { EnvComponent } from '../view/EnvComponent';
import { ControlComponent } from '../view/ControlComponent';
import { SwiperComponent } from '../view/SwiperComponent';
import EnvironmentViewModel from '../viewmodel/EnvironmentViewModel';
import { MqttMessage } from '@ohos/mqtt';
import MQTTUtil from '../common/utils/MQTTUtil';

@Entry
@Component
struct Index {
  @State item: EnvironmentViewModel = new EnvironmentViewModel();

  aboutToAppear(): void {
    new MQTTUtil().connect(
      (err: Error, data: MqttMessage) => {
        //如果没有出错就处理数据
        if (!err) {
          //解析接收到的数据为EnvironmentViewModel对象
          const next = JSON.parse(String(data.payload)) as EnvironmentViewModel;
          //确保默认字段齐全，并保留现有状态
          this.mergeItem(next);
        }
      }
    )
  }

  private mergeItem(next: EnvironmentViewModel | null) {
    if (!next) {
      return;
    }
    const target = this.item || new EnvironmentViewModel();
    target.stat = next.stat ?? target.stat;
    target.temp = next.temp ?? target.temp;
    target.hum = next.hum ?? target.hum;
    target.gas = next.gas ?? target.gas;
    target.wifiConnected = next.wifiConnected ?? target.wifiConnected;
    target.wifiSsid = next.wifiSsid ?? target.wifiSsid;
    target.mode = next.mode ?? target.mode;
    target.pumpOn = next.pumpOn ?? target.pumpOn;
    target.heaterOn = next.heaterOn ?? target.heaterOn;
    target.coolerOn = next.coolerOn ?? target.coolerOn;
    target.ledOn = next.ledOn ?? target.ledOn;
    target.alarmMessage = next.alarmMessage ?? target.alarmMessage;
    target.plant = next.plant ?? target.plant;
    target.stage = next.stage ?? target.stage;
    target.waterLowLimit = next.waterLowLimit ?? target.waterLowLimit;
    target.waterHighLimit = next.waterHighLimit ?? target.waterHighLimit;
    target.tempMin = next.tempMin ?? target.tempMin;
    target.tempMax = next.tempMax ?? target.tempMax;
    target.lightLuxTarget = next.lightLuxTarget ?? target.lightLuxTarget;
    target.lightDurationHours = next.lightDurationHours ?? target.lightDurationHours;
    this.item = target;
  }

  build() {
    Column({ space: 10 }) {
      Text("智能水生植物养殖缸监测与控制")
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(Color.Green)
        .fontColor(Color.White)
        .width('100%')
        .height(50)
        .textAlign(TextAlign.Center)

      EnvComponent({ item: this.item })
      ControlComponent({ item: $item })
      SwiperComponent({ item: this.item });
      AIComponent({ item: $item });
    }
    .height('100%')
    .width('100%')
    .padding({ bottom: 20 })
    .backgroundColor('#eeeeee')
  }
}
