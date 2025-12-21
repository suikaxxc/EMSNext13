import { MqttAsync, MqttClient, MqttMessage } from '@ohos/mqtt';
import { MQTT_URL, MQTT_CONTROL_TOPIC } from '../constants/Constant';

export default class MQTTUtil {
  private mqttAsyncClient: MqttClient | null = null;
  private static instance: MQTTUtil | null = null;

  static getInstance(): MQTTUtil {
    if (!MQTTUtil.instance) {
      MQTTUtil.instance = new MQTTUtil();
    }
    return MQTTUtil.instance;
  }

  async connect(callback: (err: Error, data: MqttMessage) => void) {

    //1、实例化MqttClient
    this.mqttAsyncClient = MqttAsync.createMqtt({
      url: MQTT_URL,
      clientId: 'harmonyos_gyz',
      persistenceType: 1,
    });

    //2、连接
    let isConnect = await this.mqttAsyncClient.connect(
      {
        userName: "userName",
        password: "password",
        connectTimeout: 300
      }
    );
    if (!isConnect) {
      return;
    }

    //3、设置回调
    this.mqttAsyncClient.messageArrived(callback)

    //4、订阅主题ems
    this.mqttAsyncClient.subscribe({
      topic: 'ems',
      qos: 2
    })
  }

  //发送控制指令
  async publish(command: object): Promise<boolean> {
    if (!this.mqttAsyncClient) {
      return false;
    }
    try {
      await this.mqttAsyncClient.publish({
        topic: MQTT_CONTROL_TOPIC,
        payload: JSON.stringify(command),
        qos: 1,
        retained: false
      });
      return true;
    } catch (error) {
      console.error('MQTT publish error:', error);
      return false;
    }
  }

  //发送设备控制指令
  async sendDeviceControl(device: string, state: boolean): Promise<boolean> {
    return this.publish({
      type: 'device_control',
      device: device,
      state: state
    });
  }

  //发送模式切换指令
  async sendModeSwitch(mode: number): Promise<boolean> {
    return this.publish({
      type: 'mode_switch',
      mode: mode
    });
  }

  //发送AI参数设置指令
  async sendAIParams(params: object): Promise<boolean> {
    return this.publish({
      type: 'ai_params',
      params: params
    });
  }
}