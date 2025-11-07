# 🔧 Sửa lỗi render.yaml

## ✅ Đã sửa:

1. **Bỏ `fromService`**: Render Blueprint không hỗ trợ `fromService` trong envVars. Sẽ cấu hình thủ công sau khi deploy.

2. **Bỏ `rasa train` ở Action Server**: Chỉ Rasa Server cần train model, Action Server không cần.

3. **Làm sạch comments**: Bỏ các comment dài có thể gây lỗi YAML parsing.

## 📝 Các bước tiếp theo:

### 1. Commit và push file đã sửa:

```bash
git add render.yaml
git commit -m "Fix render.yaml: remove fromService, fix build commands"
git push origin main
```

### 2. Trên Render Dashboard:

1. **Click nút "Retry"** trên trang Blueprint
2. Hoặc **xóa Blueprint cũ** và tạo lại:
   - Vào Dashboard
   - Xóa Blueprint hiện tại (nếu có)
   - Tạo Blueprint mới từ GitHub repository

### 3. Sau khi deploy xong, cấu hình Environment Variables:

#### Rasa Server:
```
ACTION_SERVER_URL = https://rasa-actions.onrender.com
API_URL = https://your-backend-api.com
```

#### Rasa Actions:
```
API_URL = https://your-backend-api.com
```

**Lưu ý**: 
- Thay `rasa-actions.onrender.com` bằng URL thực tế của Action Server sau khi deploy
- Thay `your-backend-api.com` bằng URL backend API của bạn

### 4. Kiểm tra logs:

Sau khi deploy, kiểm tra logs để đảm bảo:
- ✅ Dependencies được cài đúng
- ✅ Model được train thành công
- ✅ Services start không có lỗi

---

## 🎯 File render.yaml đã được sửa:

- ✅ Chỉ Rasa Server train model
- ✅ Action Server không train model
- ✅ Bỏ `fromService` (sẽ cấu hình thủ công)
- ✅ Syntax YAML đúng chuẩn

