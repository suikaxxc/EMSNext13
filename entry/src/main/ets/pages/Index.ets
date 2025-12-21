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

  // 合并接收到的数据与本地状态
  mergeReceivedData(receivedData: EnvironmentViewModel): void {
    // 保存需要保留的本地设置
    const localSettings = {
      plantType: this.item.plantType,
      growthStage: this.item.growthStage,
      mode: this.item.mode,
      recommendedTempMin: this.item.recommendedTempMin,
      recommendedTempMax: this.item.recommendedTempMax,
      recommendedWaterLevelMin: this.item.recommendedWaterLevelMin,
      recommendedWaterLevelMax: this.item.recommendedWaterLevelMax,
      recommendedLightIntensity: this.item.recommendedLightIntensity,
      recommendedLightDuration: this.item.recommendedLightDuration
    };

    // 更新为接收到的数据
    this.item = receivedData;

    // 恢复本地设置
    this.item.plantType = localSettings.plantType;
    this.item.growthStage = localSettings.growthStage;
    this.item.recommendedTempMin = localSettings.recommendedTempMin;
    this.item.recommendedTempMax = localSettings.recommendedTempMax;
    this.item.recommendedWaterLevelMin = localSettings.recommendedWaterLevelMin;
    this.item.recommendedWaterLevelMax = localSettings.recommendedWaterLevelMax;
    this.item.recommendedLightIntensity = localSettings.recommendedLightIntensity;
    this.item.recommendedLightDuration = localSettings.recommendedLightDuration;

    // 如果设备没有返回模式信息，保留本地模式
    if (receivedData.mode === undefined) {
      this.item.mode = localSettings.mode;
    }
  }

  aboutToAppear(): void {
    MQTTUtil.getInstance().connect(
      (err: Error, data: MqttMessage) => {
        //如果没有出错就处理数据
        if (!err) {
          //解析接收到的数据为EnvironmentViewModel对象
          let receivedData = JSON.parse(String(data.payload)) as EnvironmentViewModel;

          //如果实例不为空就更新状态变量
          if (receivedData) {
            this.mergeReceivedData(receivedData);
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
            ControlComponent({ item: $item })
          }
        }
        .scrollable(ScrollDirection.Vertical)
        .edgeEffect(EdgeEffect.Spring)
      } else {
        // AI养护页面
        Scroll() {
          Column({ space: 10 }) {
            PlantSelectionComponent({ item: $item })
            AIComponent({ item: $item })
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