import EnvironmentViewModel from "../viewmodel/EnvironmentViewModel";
import MQTTUtil from '../common/utils/MQTTUtil';
import { promptAction } from '@kit.ArkUI';

@Component
export struct ControlComponent {
  @Link item: EnvironmentViewModel;

  async toggleDevice(device: string, currentState: boolean) {
    // 检查是否为手动模式
    if (this.item.mode === 0) {
      promptAction.showToast({
        message: '请先切换到手动模式',
        duration: 2000
      });
      return;
    }

    const newState = !currentState;
    const success = await MQTTUtil.getInstance().sendDeviceControl(device, newState);

    if (success) {
      // 更新本地状态
      switch (device) {
        case 'pump':
          this.item.pumpOn = newState;
          break;
        case 'heater':
          this.item.heaterOn = newState;
          break;
        case 'cooler':
          this.item.coolerOn = newState;
          break;
        case 'led':
          this.item.ledOn = newState;
          break;
      }
      promptAction.showToast({
        message: `${this.getDeviceName(device)}已${newState ? '开启' : '关闭'}`,
        duration: 1500
      });
    } else {
      promptAction.showToast({
        message: '指令发送失败，请检查网络',
        duration: 2000
      });
    }
  }

  getDeviceName(device: string): string {
    switch (device) {
      case 'pump':
        return '水泵';
      case 'heater':
        return '加热器';
      case 'cooler':
        return '散热器';
      case 'led':
        return 'LED补光灯';
      default:
        return device;
    }
  }

  async switchMode() {
    const newMode = this.item.mode === 0 ? 1 : 0;
    const success = await MQTTUtil.getInstance().sendModeSwitch(newMode);

    if (success) {
      this.item.mode = newMode;
      promptAction.showToast({
        message: `已切换至${newMode === 0 ? '自动模式' : '手动模式'}`,
        duration: 1500
      });
    } else {
      promptAction.showToast({
        message: '模式切换失败，请检查网络',
        duration: 2000
      });
    }
  }

  build() {
    Column() {
      // 标题
      Row() {
        Text('⚙️ 设备控制')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')

        Button(this.item.mode === 0 ? '切换手动' : '切换自动')
          .fontSize(12)
          .height(28)
          .backgroundColor(this.item.mode === 0 ? '#1565C0' : '#2E7D32')
          .onClick(() => {
            this.switchMode();
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ bottom: 10 })

      // 设备控制按钮网格
      Grid() {
        GridItem() {
          this.DeviceControlCard('💧', '水泵', '补水', this.item.pumpOn, 'pump', '#2196F3')
        }

        GridItem() {
          this.DeviceControlCard('🔥', '加热器', '升温', this.item.heaterOn, 'heater', '#FF5722')
        }

        GridItem() {
          this.DeviceControlCard('❄️', '散热器', '降温', this.item.coolerOn, 'cooler', '#00BCD4')
        }

        GridItem() {
          this.DeviceControlCard('💡', 'LED灯', '补光', this.item.ledOn, 'led', '#FFC107')
        }
      }
      .columnsTemplate('1fr 1fr')
      .rowsTemplate('1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .width('100%')
      .height(180)
    }
    .padding(10)
    .width('94%')
    .borderRadius(10)
    .backgroundColor(Color.White)
    .margin({ left: 10, right: 10 })
  }

  @Builder
  DeviceControlCard(icon: string, name: string, action: string, isOn: boolean, device: string, activeColor: string) {
    Column() {
      Text(icon)
        .fontSize(24)

      Text(name)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#333333')
        .margin({ top: 4 })

      Text(action)
        .fontSize(10)
        .fontColor('#666666')
        .margin({ top: 2 })

      Button(isOn ? '关闭' : '开启')
        .fontSize(12)
        .height(26)
        .width(60)
        .margin({ top: 6 })
        .backgroundColor(isOn ? '#F44336' : activeColor)
        .enabled(this.item.mode === 1)
        .opacity(this.item.mode === 1 ? 1 : 0.5)
        .onClick(() => {
          this.toggleDevice(device, isOn);
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .borderRadius(8)
    .backgroundColor(isOn ? '#E8F5E9' : '#F5F5F5')
    .border({ width: 1, color: isOn ? activeColor : '#E0E0E0' })
  }
}
