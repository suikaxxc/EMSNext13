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
          this.item = Object.assign(new EnvironmentViewModel(), this.item, next);
        }
      }
    )
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
