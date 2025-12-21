//环境安全级别
export const StatusArray: string[] = ["安全", "警告", "危险", "未知"];

//服务器IP
const HOST_IP = '192.168.100.77'

//MQTT服务端地址
export const MQTT_URL = `${HOST_IP}:1883`

//大模型服务API
export const WEB_BASE_URL = `http://${HOST_IP}:8080/`