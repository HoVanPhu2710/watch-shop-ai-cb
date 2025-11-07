# 🚀 Hướng dẫn Deploy Rasa lên Render (Cách 1: Blueprint)

## ✅ Trả lời câu hỏi quan trọng:

### ❓ Có cần push model và rasaenv lên GitHub không?

**KHÔNG CẦN!** ✅

- ✅ **Model**: Render sẽ tự động train model khi deploy (hoặc bạn có thể train trước và push model lên)
- ✅ **rasaenv (virtual environment)**: Render sẽ tự tạo venv mới khi deploy, không cần push
- ✅ **`.gitignore`** đã được cấu hình đúng để ignore các file này

### 📦 Những gì CẦN push lên GitHub:

✅ **Bắt buộc:**

- `config.yml` - Cấu hình Rasa
- `domain.yml` - Domain của bot
- `data/` - Training data (nlu.yml, stories.yml, rules.yml)
- `actions/` - Custom actions
- `requirements.txt` - Dependencies
- `endpoints.yml` - Endpoint configuration
- `render.yaml` - **File cấu hình Render (QUAN TRỌNG!)**
- `Procfile` - Cho Heroku/Railway (optional)
- `runtime.txt` - Python version (optional)

❌ **KHÔNG cần push:**

- `models/` - Model sẽ được train trên Render
- `rasaenv/` - Virtual environment
- `.rasa/` - Cache files
- `*.log` - Log files

---

## 📋 Các bước deploy chi tiết:

### Bước 1: Kiểm tra và commit code

```bash
# Kiểm tra status
git status

# Thêm các file cần thiết
git add render.yaml
git add Procfile
git add runtime.txt
git add README_DEPLOY.md
git add actions/actions.py
git add endpoints.yml

# Commit
git commit -m "Add Render deployment configuration"

# Push lên GitHub
git push origin main
```

### Bước 2: Đăng ký/Đăng nhập Render

1. Vào [https://render.com](https://render.com)
2. Đăng ký bằng GitHub account (miễn phí)
3. Xác nhận email nếu cần

### Bước 3: Tạo Blueprint từ GitHub

1. Vào **Render Dashboard**: [https://dashboard.render.com](https://dashboard.render.com)
2. Click nút **New +** (góc trên bên phải)
3. Chọn **Blueprint**
4. Render sẽ hỏi bạn kết nối GitHub repository:
   - Click **Connect GitHub** nếu chưa kết nối
   - Chọn repository `chatbot2` (hoặc tên repo của bạn)
   - Click **Connect**

### Bước 4: Render tự động tạo services

Sau khi kết nối, Render sẽ:

- ✅ Đọc file `render.yaml`
- ✅ Tự động tạo 2 services:
  - `rasa-server` (Rasa API Server)
  - `rasa-actions` (Rasa Action Server)
- ✅ Bắt đầu build và deploy

**Thời gian:** Khoảng 5-10 phút cho lần đầu (do phải cài dependencies và train model)

### Bước 5: Cấu hình Environment Variables

Sau khi deploy xong, cần cấu hình:

#### 5.1. Lấy URL của Action Server

1. Vào service `rasa-actions` trên Render Dashboard
2. Copy URL (ví dụ: `https://rasa-actions.onrender.com`)

#### 5.2. Cấu hình Rasa Server

1. Vào service `rasa-server`
2. Vào tab **Environment**
3. Thêm/Chỉnh sửa các biến:

   ```
   ACTION_SERVER_URL = https://rasa-actions.onrender.com
   API_URL = https://your-backend-api.com
   ```

   (Thay `your-backend-api.com` bằng URL thực tế của backend API)

4. Click **Save Changes**
5. Render sẽ tự động redeploy

#### 5.3. Cấu hình Rasa Actions

1. Vào service `rasa-actions`
2. Vào tab **Environment**
3. Thêm biến:
   ```
   API_URL = https://your-backend-api.com
   ```
4. Click **Save Changes**

### Bước 6: Kiểm tra Model Training

Render sẽ tự động train model khi deploy. Để kiểm tra:

1. Vào service `rasa-server` hoặc `rasa-actions`
2. Vào tab **Logs**
3. Tìm dòng: `Your Rasa model is trained and saved at...`
4. Nếu thấy lỗi về model, có thể cần thêm build command để train model

**Lưu ý:** Nếu model quá lớn hoặc train quá lâu, có thể:

- Train model local trước
- Push model lên GitHub (tạm thời bỏ ignore)
- Hoặc dùng Git LFS cho model files

### Bước 7: Test API

Sau khi deploy xong, test API:

```bash
# Test Rasa Server
curl -X POST https://your-rasa-server.onrender.com/webhooks/rest/webhook \
  -H "Content-Type: application/json" \
  -d '{"message": "xin chào"}'

# Test Action Server
curl https://your-rasa-actions.onrender.com/webhook
```

---

## 🔧 Troubleshooting

### Lỗi: "No model found"

**Giải pháp 1:** Thêm build command để train model:

Trong `render.yaml`, thêm vào `buildCommand`:

```yaml
buildCommand: pip install -r requirements.txt && rasa train
```

**Giải pháp 2:** Train model local và push lên (tạm thời):

```bash
# Tạm thời bỏ ignore model
git add -f models/*.tar.gz
git commit -m "Add trained model"
git push
```

Sau đó xóa model khỏi Git sau khi deploy xong.

### Lỗi: "Action server not reachable"

- Kiểm tra `ACTION_SERVER_URL` có đúng format không (không có `/webhook` ở cuối)
- Đảm bảo Action Server đã deploy xong và running
- Kiểm tra logs của Action Server

### Lỗi: Build timeout

- Model quá lớn hoặc train quá lâu
- Giải pháp: Train model local trước, sau đó push lên

### Lỗi: "Port already in use"

- Render tự động set `$PORT`, không cần hardcode
- Đảm bảo start command dùng `$PORT` thay vì số cụ thể

---

## 📝 Checklist trước khi deploy

- [ ] Đã commit và push `render.yaml` lên GitHub
- [ ] Đã commit và push `requirements.txt`
- [ ] Đã commit và push `actions/actions.py` (với API_BASE_URL)
- [ ] Đã commit và push `endpoints.yml`
- [ ] Đã commit và push `config.yml`, `domain.yml`, `data/`
- [ ] Đã có tài khoản Render
- [ ] Đã biết URL của backend API (để set `API_URL`)

---

## 🎯 Tóm tắt quy trình

1. **Local**: Train model, test local
2. **Git**: Commit và push code (KHÔNG push model và venv)
3. **Render**: Tạo Blueprint từ GitHub
4. **Render**: Tự động tạo 2 services từ `render.yaml`
5. **Render**: Tự động train model khi deploy
6. **Render**: Cấu hình Environment Variables
7. **Test**: Kiểm tra API hoạt động

---

## 💡 Tips

1. **Lần đầu deploy sẽ lâu** (5-10 phút) vì phải:

   - Cài dependencies
   - Train model
   - Build services

2. **Các lần deploy sau sẽ nhanh hơn** (2-3 phút) nếu chỉ update code

3. **Monitor logs** để biết quá trình deploy:

   - Vào service → Tab **Logs**
   - Xem real-time logs

4. **Free tier limitations**:
   - Services sẽ sleep sau 15 phút không dùng
   - Lần đầu wake up sẽ mất 30-60 giây
   - Có thể upgrade lên paid plan để tránh sleep

---

Chúc bạn deploy thành công! 🎉
