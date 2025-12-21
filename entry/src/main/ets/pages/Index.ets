import { AIComponent } from '../view/AIComponent';
import { EnvComponent } from '../view/EnvComponent';
import { SwiperComponent } from '../view/SwiperComponent';
import { ControlComponent } from '../view/ControlComponent';
import { PlantSelectionComponent } from '../view/PlantSelectionComponent';
import EnvironmentViewModel from '../viewmodel/EnvironmentViewModel';
import { MqttMessage } from '@ohos/mqtt';
import MQTTUtil from '../common/utils/MQTTUtil';

@Entry
@Component
struct Index {
  @State item: EnvironmentViewModel = new EnvironmentViewModel();
  @State currentTab: number = 0;

  aboutToAppear(): void {
    MQTTUtil.getInstance().connect(
      (err: Error, data: MqttMessage) => {
        //如果没有出错就处理数据
        if (!err) {
          //解析接收到的数据为EnvironmentViewModel对象
          let receivedData = JSON.parse(String(data.payload)) as EnvironmentViewModel;

          //如果实例不为空就更新状态变量
          if (receivedData) {
            // 保留本地设置的植物和阶段信息
            const plantType = this.item.plantType;
            const growthStage = this.item.growthStage;
            const mode = this.item.mode;
            const recommendedTempMin = this.item.recommendedTempMin;
            const recommendedTempMax = this.item.recommendedTempMax;
            const recommendedWaterLevelMin = this.item.recommendedWaterLevelMin;
            const recommendedWaterLevelMax = this.item.recommendedWaterLevelMax;
            const recommendedLightIntensity = this.item.recommendedLightIntensity;
            const recommendedLightDuration = this.item.recommendedLightDuration;

            this.item = receivedData;
            this.item.plantType = plantType;
            this.item.growthStage = growthStage;
            // 如果设备没有返回模式信息，保留本地模式
            if (receivedData.mode === undefined) {
              this.item.mode = mode;
            }
            // 保留推荐参数
            this.item.recommendedTempMin = recommendedTempMin;
            this.item.recommendedTempMax = recommendedTempMax;
            this.item.recommendedWaterLevelMin = recommendedWaterLevelMin;
            this.item.recommendedWaterLevelMax = recommendedWaterLevelMax;
            this.item.recommendedLightIntensity = recommendedLightIntensity;
            this.item.recommendedLightDuration = recommendedLightDuration;
          }
        }
      }
    )
  }

  build() {
    Column({ space: 8 }) {
      // 标题栏
      Row() {
        Text("🌿 智能水生植物养殖缸")
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .width('100%')
      .height(50)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#2E7D32')

      // Tab 切换
      Row() {
        this.TabButton('监控', 0, '📊')
        this.TabButton('控制', 1, '⚙️')
        this.TabButton('AI养护', 2, '🤖')
      }
      .width('94%')
      .justifyContent(FlexAlign.SpaceAround)
      .backgroundColor(Color.White)
      .borderRadius(10)
      .padding(5)

      // 内容区域
      if (this.currentTab === 0) {
        // 监控页面
        Scroll() {
          Column({ space: 10 }) {
            EnvComponent({ item: this.item })
            SwiperComponent({ item: this.item })
          }
        }
        .scrollable(ScrollDirection.Vertical)
        .edgeEffect(EdgeEffect.Spring)
      } else if (this.currentTab === 1) {
        // 控制页面
        Scroll() {
          Column({ space: 10 }) {
            EnvComponent({ item: this.item })
            ControlComponent({ item: this.item })
          }
        }
        .scrollable(ScrollDirection.Vertical)
        .edgeEffect(EdgeEffect.Spring)
      } else {
        // AI养护页面
        Scroll() {
          Column({ space: 10 }) {
            PlantSelectionComponent({ item: this.item })
            AIComponent({ item: this.item })
          }
        }
        .scrollable(ScrollDirection.Vertical)
        .edgeEffect(EdgeEffect.Spring)
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#ECEFF1')
  }

  @Builder
  TabButton(label: string, index: number, icon: string) {
    Column() {
      Text(icon)
        .fontSize(20)
      Text(label)
        .fontSize(12)
        .fontColor(this.currentTab === index ? '#2E7D32' : '#666666')
        .fontWeight(this.currentTab === index ? FontWeight.Bold : FontWeight.Normal)
    }
    .padding({ left: 20, right: 20, top: 8, bottom: 8 })
    .backgroundColor(this.currentTab === index ? '#E8F5E9' : Color.Transparent)
    .borderRadius(8)
    .onClick(() => {
      this.currentTab = index;
    })
  }
}