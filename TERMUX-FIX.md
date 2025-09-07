# 🔧 Termux Binary Fix Guide

## ❌ المشكلة (The Problem)

```
bash: ./slipstream-client: cannot execute binary file: Exec format error
```

**السبب:** الملفات التنفيذية مبينة لـ x86_64 (Intel/AMD) لكن Termux يعمل على ARM64 (aarch64)

## ✅ الحلول (Solutions)

### 1️⃣ البناء من المصدر (Recommended)

```bash
# تشغيل سكريبت البناء التلقائي
chmod +x build-termux.sh
./build-termux.sh
```

### 2️⃣ البناء اليدوي

```bash
# تحديث الحزم
pkg update && pkg upgrade -y

# تثبيت أدوات البناء
pkg install -y build-essential cmake ninja-build pkg-config openssl-tool git

# بناء المشروع
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j4

# نسخ الملفات التنفيذية
cp slipstream-* ..
chmod +x slipstream-*

# العودة للمجلد الرئيسي
cd ..
```

### 3️⃣ استخدام QEMU (للاستخدام المؤقت)

```bash
# تثبيت QEMU
pkg install -y qemu-user-x86_64

# تشغيل الملفات
qemu-x86_64 ./slipstream-client --help
qemu-x86_64 ./slipstream-server --help
```

## 🚀 التشغيل بعد الإصلاح

### تشغيل العميل
```bash
./slipstream-client \
    --congestion-control=bbr \
    --tcp-listen-port=7000 \
    --resolver=YOUR_SERVER_IP:5301 \
    --domain=dns.fastvpn.uk \
    --keep-alive-interval=1000
```

### تشغيل الخادم
```bash
# إنشاء الشهادات
mkdir -p certs
openssl req -x509 -newkey rsa:4096 \
    -keyout certs/key.pem \
    -out certs/cert.pem \
    -days 365 \
    -nodes \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=dns.fastvpn.uk"

# تشغيل الخادم
./slipstream-server \
    --target-address=0.0.0.0:22 \
    --domain=dns.fastvpn.uk \
    --cert=certs/cert.pem \
    --key=certs/key.pem \
    --dns-listen-port=5301
```

## 🔍 التحقق من الإصلاح

```bash
# فحص نوع الملف
file slipstream-client
file slipstream-server

# يجب أن تظهر:
# slipstream-client: ELF 64-bit LSB pie executable, ARM aarch64, version 1 (SYSV)
# slipstream-server: ELF 64-bit LSB pie executable, ARM aarch64, version 1 (SYSV)

# اختبار التشغيل
./slipstream-client --help
./slipstream-server --help
```

## 📱 نصائح Termux

### منع إغلاق التطبيق
```bash
# منع النوم
termux-wake-lock

# تشغيل في الخلفية
screen -dmS slipstream ./slipstream-server [options]
```

### مراقبة العمليات
```bash
# عرض العمليات
ps aux | grep slipstream

# مراقبة الشبكة
netstat -tulpn | grep :5301
```

### إدارة الشاشات
```bash
# عرض الجلسات
screen -ls

# الدخول لجلسة
screen -r slipstream

# الخروج من الجلسة (بدون إغلاق)
Ctrl+A, D
```

## 🆘 استكشاف الأخطاء

### خطأ في البناء
```bash
# تنظيف البناء السابق
rm -rf build

# إعادة البناء
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j4
```

### خطأ في الصلاحيات
```bash
chmod +x slipstream-*
```

### خطأ في الشهادات
```bash
# إعادة إنشاء الشهادات
rm -rf certs
mkdir certs
openssl req -x509 -newkey rsa:4096 \
    -keyout certs/key.pem \
    -out certs/cert.pem \
    -days 365 \
    -nodes \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=YOUR_DOMAIN"
```

## 📞 الدعم

إذا واجهت مشاكل:
1. تأكد من تحديث Termux
2. تحقق من اتصال الإنترنت
3. استخدم البناء من المصدر
4. راجع ملفات السجل

---

**ملاحظة:** هذا الإصلاح مطلوب مرة واحدة فقط. بعد البناء الصحيح، ستعمل الملفات التنفيذية بشكل طبيعي.
