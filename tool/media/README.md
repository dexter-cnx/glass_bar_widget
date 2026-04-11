# Media Tools

This folder contains scripts for capturing demo screenshots and building animated GIFs.

## English

### Web demo

Use this when you want to capture frames from the Flutter web demo.

1. Build and serve the demo:

   ```bash
   cd example
   flutter build web --release
   python3 -m http.server 8080 --directory build/web
   ```

2. In another terminal, run:

   ```bash
   cd ..
   make media-web-browser
   ```

3. Press `Space` to capture the current frame.
4. Press `Esc` to finish.
5. The script saves PNG frames in `doc/media/frames/` and builds `doc/media/glass_bar_demo.gif`.

Useful environment variables:

- `DEMO_URL` - demo URL, default `http://127.0.0.1:8080`
- `MANUAL` - `true` or `false`
- `HEADLESS` - `true` or `false`
- `MAX_FRAMES` - maximum number of frames to capture
- `AUTO_GIF` - `true` or `false`

### Android emulator

Use this when you want to capture frames from the Android example app.

1. Start an Android emulator with `adb` access.
2. Run:

   ```bash
   bash tool/media/capture_android_emulator.sh
   ```

3. Press `Space` to capture the current frame.
4. Press `Esc` to finish.
5. The script saves PNG frames in `doc/media/frames/` and builds `doc/media/glass_bar_demo.gif`.

### Android real device

Use this when you want to capture frames from a physical Android phone.

Prerequisites:

- Enable USB debugging on the device.
- Connect the device with USB or a trusted ADB connection.
- Make sure `adb devices` lists the phone.
- Unlock the screen before capturing.

1. Install and run the debug app on the device.
2. Run:

   ```bash
   ANDROID_SERIAL=<device-serial> bash tool/media/capture_android_emulator.sh
   ```

   If only one device is connected, you can omit `ANDROID_SERIAL`.

3. Press `Space` to capture the current frame.
4. Press `Esc` to finish.
5. The script saves PNG frames in `doc/media/frames/` and builds `doc/media/glass_bar_demo.gif`.

Useful note:

- The script uses `adb`, so it works for a real device as long as the device is visible to ADB.

## ไทย

### สำหรับเว็บเดโม

ใช้วิธีนี้เมื่ออยาก capture เฟรมจาก Flutter web demo

1. Build และเปิดเซิร์ฟเวอร์เดโม:

   ```bash
   cd example
   flutter build web --release
   python3 -m http.server 8080 --directory build/web
   ```

2. เปิดอีก terminal แล้วรัน:

   ```bash
   cd ..
   make media-web-browser
   ```

3. กด `Space` เพื่อ capture เฟรมปัจจุบัน
4. กด `Esc` เพื่อจบการ capture
5. สคริปต์จะบันทึก PNG ไว้ที่ `doc/media/frames/` และสร้าง GIF ที่ `doc/media/glass_bar_demo.gif`

ตัวแปรที่ปรับได้:

- `DEMO_URL` - URL ของเดโม, ค่าเริ่มต้น `http://127.0.0.1:8080`
- `MANUAL` - `true` หรือ `false`
- `HEADLESS` - `true` หรือ `false`
- `MAX_FRAMES` - จำนวนเฟรมสูงสุด
- `AUTO_GIF` - `true` หรือ `false`

### สำหรับ Android emulator

ใช้วิธีนี้เมื่ออยาก capture เฟรมจากแอป Android example

1. เปิด Android emulator ที่ใช้งาน `adb` ได้
2. รัน:

   ```bash
   bash tool/media/capture_android_emulator.sh
   ```

3. กด `Space` เพื่อ capture เฟรมปัจจุบัน
4. กด `Esc` เพื่อจบการ capture
5. สคริปต์จะบันทึก PNG ไว้ที่ `doc/media/frames/` และสร้าง GIF ที่ `doc/media/glass_bar_demo.gif`

### สำหรับ Android เครื่องจริง

ใช้วิธีนี้เมื่ออยาก capture เฟรมจากโทรศัพท์ Android เครื่องจริง

สิ่งที่ต้องมี:

- เปิด USB debugging บนเครื่อง
- ต่อสาย USB หรือเชื่อมต่อ ADB ให้เครื่องมองเห็นได้
- ให้ `adb devices` แสดงรายการเครื่อง
- ปลดล็อกหน้าจอก่อนเริ่ม capture

1. ติดตั้งและรันแอป debug บนเครื่อง
2. รัน:

   ```bash
   ANDROID_SERIAL=<device-serial> bash tool/media/capture_android_emulator.sh
   ```

   ถ้ามีเครื่องเดียว สามารถไม่ใส่ `ANDROID_SERIAL` ได้

3. กด `Space` เพื่อ capture เฟรมปัจจุบัน
4. กด `Esc` เพื่อจบการ capture
5. สคริปต์จะบันทึก PNG ไว้ที่ `doc/media/frames/` และสร้าง GIF ที่ `doc/media/glass_bar_demo.gif`

หมายเหตุ:

- สคริปต์ใช้ `adb` ดังนั้นจะใช้กับเครื่องจริงได้ถ้าเครื่องถูกมองเห็นโดย ADB แล้ว
