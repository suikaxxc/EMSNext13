import EnvironmentViewModel from "../viewmodel/EnvironmentViewModel";
import ResultData from "../model/ResultData";
import HttpUtil from "../common/utils/HttpUtil";
import { promptAction } from '@kit.ArkUI';

@Component
export struct ControlComponent {
  @Link
  item: EnvironmentViewModel;
  @State busyAction: string = '';

  private updateItem(partial: Partial<EnvironmentViewModel>) {
    if (!partial) {
      return;
    }
    for (let key in partial) {
      (this.item as Record<string, unknown>)[key] = (partial as Record<string, unknown>)[key];
    }
  }

  private sendControl(action: string, value: string | boolean): Promise<boolean> {
    this.busyAction = action;
    return HttpUtil.post<ResultData, object>('control/command', {
      action: action,
      value: value,
      mode: this.item.mode
    }).then((data: ResultData) => {
      promptAction.showToast({
        message: data?.message || '指令已发送',
        duration: 2000
      });
      return true;
    }).catch((err: unknown) => {
      const message = typeof err === 'object' && err !== null && 'message' in err ? (err as { message?: string }).message : '';
      promptAction.showToast({
        message: `指令未确认：${message || '网络不可用'}`,
        duration: 2000
      });
      return false;
    }).finally(() => {
      this.busyAction = '';
    })
  }

  private onModeChange(isOn: boolean) {
    const mode = isOn ? 'auto' : 'manual';
    this.updateItem({ mode: mode });
    this.sendControl('mode', mode);
  }

  private onToggle(field: 'pumpOn' | 'ledOn' | 'heaterOn' | 'coolerOn', value: boolean) {
    const change: Partial<EnvironmentViewModel> = {};
    change[field] = value;
    this.updateItem(change);
    this.sendControl(field as string, value);
  }

  private toggleHeater(isOn: boolean) {
    const previous = { heaterOn: this.item.heaterOn, coolerOn: this.item.coolerOn };
    this.updateItem({ heaterOn: isOn, coolerOn: false });
    this.sendControl('heaterOn', isOn).then((ok: boolean) => {
      if (!ok) {
        this.updateItem(previous);
        return;
      }
      this.sendControl('coolerOn', false);
    });
  }

  private toggleCooler(isOn: boolean) {
    const previous = { heaterOn: this.item.heaterOn, coolerOn: this.item.coolerOn };
    this.updateItem({ heaterOn: false, coolerOn: isOn });
    this.sendControl('coolerOn', isOn).then((ok: boolean) => {
      if (!ok) {
        this.updateItem(previous);
        return;
      }
      this.sendControl('heaterOn', false);
    });
  }

  build() {
    Column() {
      Row() {
        Text('自动/手动')
          .fontSize(16)
        Toggle({ type: ToggleType.Switch, isOn: this.item.mode !== 'manual' })
          .onChange((isOn: boolean) => this.onModeChange(isOn))
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ left: 10, right: 10, top: 4, bottom: 4 })

      Row() {
        Text('强制补水')
          .fontSize(16)
        Toggle({ type: ToggleType.Switch, isOn: this.item.pumpOn })
          .enabled(this.item.mode === 'manual')
          .onChange((isOn: boolean) => this.onToggle('pumpOn', isOn))
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ left: 10, right: 10, top: 4, bottom: 4 })

      Row() {
        Text('LED补光')
          .fontSize(16)
        Toggle({ type: ToggleType.Switch, isOn: this.item.ledOn })
          .enabled(this.item.mode === 'manual')
          .onChange((isOn: boolean) => this.onToggle('ledOn', isOn))
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ left: 10, right: 10, top: 4, bottom: 4 })

      Row() {
        Text('加热/恒温')
          .fontSize(16)
        Toggle({ type: ToggleType.Switch, isOn: this.item.heaterOn })
          .enabled(this.item.mode === 'manual')
          .onChange((isOn: boolean) => {
            this.toggleHeater(isOn);
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ left: 10, right: 10, top: 4, bottom: 4 })

      Row() {
        Text('散热/风扇')
          .fontSize(16)
        Toggle({ type: ToggleType.Switch, isOn: this.item.coolerOn })
          .enabled(this.item.mode === 'manual')
          .onChange((isOn: boolean) => {
            this.toggleCooler(isOn);
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ left: 10, right: 10, top: 4, bottom: 4 })

      Row() {
        Button(this.busyAction ? '指令发送中…' : '测试蜂鸣器报警')
          .backgroundColor(Color.Green)
          .fontColor(Color.White)
          .enabled(this.busyAction === '')
          .onClick(() => {
            this.sendControl('alarm', true);
          })
        Button('Wi-Fi重连')
          .backgroundColor(Color.White)
          .border({ color: Color.Green, width: 1 })
          .fontColor(Color.Green)
          .onClick(() => this.sendControl('wifiReconnect', true))
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ left: 10, right: 10, top: 6, bottom: 2 })

      Text('提示：自动模式下阈值由AI策略动态更新，手动模式可以强制控制补水、温控与补光。')
        .fontSize(13)
        .lineHeight(20)
        .fontColor('#666666')
        .padding({ left: 10, right: 10, top: 6 })
    }
    .width('94%')
    .backgroundColor(Color.White)
    .borderRadius(10)
    .margin({ left: 10, right: 10 })
    .padding(6)
  }
}
