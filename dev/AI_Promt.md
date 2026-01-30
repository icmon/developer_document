 
ผมต้องการสร้าง ระบบ notification  system โดยใช้

NustJS framwork By Node JS

1.type orm
2.database postgress sql
3.socket.io
4.mqtt
5.redis

1.ออกแบบ ระบบ notification data flow 
2.ออกแบบ table database postgress sql
3.ออกแบบ Quit ใช่้ socket.io / mqtt / redis
4.ออกแบบ หน้ารายงาน
5.ออกแบบ ระบบตั้งค้า notification

notification  alarm

   1.ชื่อ Device 
   2.ข้อมูล Device เช่น  humidity  56 %
   3.วันเวลา
   4.สถานะ เช่น  1.Normal  2.Worming 3.Recovery Worming  3.Alarm    4.Recovery Alarm
   5.notification log  เก็บเวลา 
   6.นำเวลาแจ่งเตียน ล่าสุด มา เทียเวลาปจุบัน เกิน ค่าที่กำหนดไหม เช่น 10 นาที  1.Normal  หากยัง มีสถานะ  2.Worming 3.Recovery Worming  3.Alarm    4.Recovery Alarm  ให้เจ้งเตียo ซ้ำทุก  10 นาที  หาก  Normal  ให้แเจ้งเตียน หยุด  สถานะ Normal แล้วหยุด แเจ้งเตียน
   7.หาก สถานะ 1.Normal ไม่มีการ  แเจ้งเตียน
   8.เก็นประวัติการ แเจ้งเตียน
   9.กำหนด ค่าการแจ้งเตียชนแต่ละช่วง  1.Normal  2.Worming 3.Recovery Worming  3.Alarm    4.Recovery Alarm

ช่องทาง การ ให้เลืกได้มากว่า 1 ช่องทาง โดยมี รูปแบบดังนี้

1.Line notification
2.discord notification
3.telegram notification
4.sms  notification
5.AI CHERT BOT  notification
6.สร้าง entities  type orm
7.สร้าง modules rest api  
8.สร้าง level notification



ออกแบบรูป monitorring  htnl 5 CSS  ICON 
URL : https://preview.tabler.io
ICON : https://preview.tabler.io/icons.html

การแสดง ข้อมูล 
1.ชื่อ Device sensor
2.ข้อมูล sensor เช่น  humidity  56 %
3.ข้อมูล สถานะ  เช่น  1.Normal  2.Worming 3.Recovery Worming  3.Alarm    4.Recovery Alarm
4.แสดงสัญลักษณ์ icon
5.แสดงสี  ไฟกระพริบ 1.Normal สีเขียว 2.Worming สีส้ม 3.Alarm  สีแดง
6.แสดง history log สถานะ

1.ชื่อ Device IO เช่น  Air Conditioner
2.ข้อมูล Device IO เช่น   Air  ON / OFF
3.ข้อมูล สถานะการทำงาน  Device IO เช่น  ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
4.แสดงสัญลักษณ์ icon
5.แสดง history log สถานะ


group 1
 sensor  
   - temperature sensor
   - humidity sensor
   - CO2 sensor 
   - O2 sensor (Oxygen Sensor)

group 2
 sensor 
    -temperature sensor
    -humidity sensor
    -Smoke Detector sensor
    	-Smoke Detector (เซ็นเซอร์ตรวจจับควัน)
    	-Heat Detector (เซ็นเซอร์ตรวจจับความร้อน):
	-Rate-of-Rise: ตรวจจับการเพิ่มขึ้นของอุณหภูมิอย่างรวดเร็ว.
	-Fixed Temperature: ตรวจจับเมื่ออุณหภูมิถึงระดับที่กำหนดไว้.

group 3
 sensor 
     -Temperature sensor
     -Volt sensor
     -Amp sensor
     -Water Leak Detection sensor
       --Wire and Spot Leak Detection
 IO
     -Switch ON  OFF status
group 4
  ข้อมูล สถานะการทำงาน  Device IO เช่น  ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -input1 IO 
    -Air Conditioner 1 สถานะการทำงาน   ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -Air Conditioner 2 สถานะการทำงาน   ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -UPS1 สถานะการทำงาน   ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -UPS2 สถานะการทำงาน   ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -water leak  สถานะการทำงาน   ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -HSSD sensor  High Sensitivity Smoke Detection (ระบบตรวจจับควันไฟความไวสูง) 
      สถานะการทำงาน   ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -Door sensor ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง เซ็นเซอร์ประตู (Door Sensor) คืออุปกรณ์ตรวจจับการเปิด-ปิดประตู (หรือหน้าต่าง, ตู้) 

group 5.แสดง history log สถานะ
   1.ชื่อ Device 
   2.ข้อมูล Device เช่น  humidity  56 %
   3.วันเวลา
   4.สถานะ เช่น  1.Normal  2.Worming 3.Recovery Worming  3.Alarm    4.Recovery Alarm




``` 