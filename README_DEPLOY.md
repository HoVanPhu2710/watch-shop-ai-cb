# Hướng dẫn Deploy Rasa Chatbot lên Cloud

Tài liệu này hướng dẫn cách deploy Rasa chatbot lên các nền tảng cloud, đặc biệt là **Render**.

## 📋 Mục lục

1. [Render (Khuyến nghị)](#render)
2. [Railway](#railway)
3. [Heroku](#heroku)
4. [AWS/GCP/Azure](#aws-gcp-azure)
5. [Cấu hình môi trường](#cấu-hình-môi-trường)
6. [Troubleshooting](#troubleshooting)

---

## 🚀 Render

### Render có phù hợp không?

**Có!** Render là một nền tảng tuyệt vời để deploy Rasa vì:
- ✅ Hỗ trợ Python và Docker
- ✅ Free tier cho development
- ✅ Tự động deploy từ Git
- ✅ Hỗ trợ nhiều services (web, background workers)
- ✅ SSL tự động
- ✅ Dễ cấu hình

### Các bước deploy lên Render:

#### 1. Chuẩn bị

Đảm bảo bạn đã:
- ✅ Có model đã train (file `.tar.gz` trong thư mục `models/`)
- ✅ Code đã được push lên GitHub/GitLab
- ✅ Có tài khoản Render (miễn phí tại [render.com](https://render.com))

#### 2. Tạo 2 Web Services trên Render

Rasa cần 2 services:
- **Rasa Server**: API chính (port 5005)
- **Rasa Action Server**: Custom actions (port 5055)

#### 3. Deploy Rasa Server

1. Vào [Render Dashboard](https://dashboard.render.com)
2. Click **New +** → **Web Service**
3. Kết nối repository GitHub của bạn
4. Cấu hình:
   - **Name**: `rasa-server`
   - **Environment**: `Python 3`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `rasa run --enable-api --cors "*" --port $PORT`
   - **Plan**: Starter (free) hoặc Professional (có phí)

5. Thêm Environment Variables:
   ```
   PORT=5005
   ACTION_SERVER_URL=https://rasa-actions.onrender.com
   API_URL=https://your-backend-api.com
   ```

#### 4. Deploy Rasa Action Server

1. Tạo Web Service thứ 2:
   - **Name**: `rasa-actions`
   - **Environment**: `Python 3`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `rasa run actions --port $PORT`
   - **Plan**: Starter

2. Thêm Environment Variables:
   ```
   PORT=5055
   API_URL=https://your-backend-api.com
   ```

#### 5. Sử dụng render.yaml (Tự động)

Thay vì tạo thủ công, bạn có thể dùng file `render.yaml`:

1. Push code lên GitHub
2. Vào Render Dashboard → **New +** → **Blueprint**
3. Kết nối repository
4. Render sẽ tự động tạo 2 services từ `render.yaml`

**Lưu ý**: Sau khi deploy, cần cập nhật `ACTION_SERVER_URL` trong Rasa Server service với URL thực tế của Action Server.

#### 6. Train Model trước khi Deploy

Nếu chưa có model, train trước:

```bash
rasa train
```

Model sẽ được tạo trong thư mục `models/`. Render sẽ tự động sử dụng model mới nhất.

---

## 🚂 Railway

Railway cũng là lựa chọn tốt:

1. Đăng ký tại [railway.app](https://railway.app)
2. Tạo project mới
3. Deploy từ GitHub
4. Cấu hình 2 services tương tự Render

**Railway có ưu điểm**: Free tier rộng rãi hơn, nhưng có thể phức tạp hơn một chút.

---

## 🟣 Heroku

Heroku đã ngừng free tier, nhưng vẫn có thể dùng:

1. Tạo file `Procfile`:
   ```
   web: rasa run --enable-api --cors "*" --port $PORT
   worker: rasa run actions --port $PORT
   ```

2. Deploy bằng Heroku CLI hoặc GitHub integration

**Lưu ý**: Heroku yêu cầu trả phí sau khi hết free tier.

---

## ☁️ AWS / GCP / Azure

### AWS (Elastic Beanstalk / ECS)

- **Elastic Beanstalk**: Dễ deploy, tự động scale
- **ECS**: Container-based, linh hoạt hơn
- **EC2**: Tự quản lý hoàn toàn

### Google Cloud Platform

- **Cloud Run**: Serverless, trả theo usage
- **App Engine**: Managed platform
- **Compute Engine**: VM tự quản lý

### Azure

- **App Service**: Managed platform
- **Container Instances**: Container-based
- **Virtual Machines**: VM tự quản lý

---

## ⚙️ Cấu hình môi trường

### Environment Variables cần thiết:

#### Rasa Server:
```bash
PORT=5005
ACTION_SERVER_URL=https://your-action-server.com
API_URL=https://your-backend-api.com
```

#### Rasa Action Server:
```bash
PORT=5055
API_URL=https://your-backend-api.com
```

### Cấu hình endpoints.yml

File `endpoints.yml` đã được cấu hình để sử dụng biến môi trường:
```yaml
action_endpoint:
  url: "${ACTION_SERVER_URL:-http://localhost:5055}/webhook"
```

### Cấu hình actions.py

File `actions/actions.py` đã được cập nhật để sử dụng `API_BASE_URL` từ biến môi trường `API_URL`.

---

## 🔧 Troubleshooting

### Lỗi: "No model found"

**Giải pháp**: 
- Đảm bảo đã train model: `rasa train`
- Model phải có trong thư mục `models/`
- Render sẽ tự động sử dụng model mới nhất

### Lỗi: "Action server not reachable"

**Giải pháp**:
- Kiểm tra `ACTION_SERVER_URL` trong Rasa Server service
- Đảm bảo Action Server đã được deploy và running
- Kiểm tra URL có đúng format: `https://rasa-actions.onrender.com` (không có `/webhook` ở cuối)

### Lỗi: "Connection timeout to API"

**Giải pháp**:
- Kiểm tra `API_URL` environment variable
- Đảm bảo backend API đã được deploy và accessible
- Kiểm tra CORS settings trên backend API

### Lỗi: "Port already in use"

**Giải pháp**:
- Render tự động set `$PORT`, không cần hardcode
- Đảm bảo start command sử dụng `$PORT` thay vì số cụ thể

### Model quá lớn

**Giải pháp**:
- Sử dụng Git LFS cho model files
- Hoặc upload model lên cloud storage và download khi deploy
- Hoặc train model nhẹ hơn

### Build timeout

**Giải pháp**:
- Tối ưu `requirements.txt`, loại bỏ dependencies không cần thiết
- Sử dụng Python base image nhẹ hơn
- Cache dependencies nếu có thể

---

## 📝 Checklist trước khi deploy

- [ ] Đã train model (`rasa train`)
- [ ] Model có trong thư mục `models/`
- [ ] Đã cập nhật `API_URL` trong environment variables
- [ ] Đã test local với `rasa run` và `rasa run actions`
- [ ] Code đã được push lên GitHub
- [ ] Đã cấu hình `ACTION_SERVER_URL` đúng
- [ ] Backend API đã được deploy và accessible

---

## 🔗 Tài liệu tham khảo

- [Rasa Deployment Guide](https://rasa.com/docs/rasa/deploy)
- [Render Documentation](https://render.com/docs)
- [Railway Documentation](https://docs.railway.app)
- [Heroku Python Guide](https://devcenter.heroku.com/articles/getting-started-with-python)

---

## 💡 Tips

1. **Sử dụng Render Blueprint**: File `render.yaml` giúp deploy tự động, không cần cấu hình thủ công
2. **Monitor logs**: Luôn kiểm tra logs trên Render dashboard khi có lỗi
3. **Test local trước**: Đảm bảo mọi thứ hoạt động local trước khi deploy
4. **Environment variables**: Không hardcode URLs, luôn dùng environment variables
5. **Model versioning**: Tag model versions để dễ rollback nếu cần

---

## ❓ Câu hỏi thường gặp

**Q: Render có free không?**
A: Có, Render có free tier cho development, nhưng services sẽ sleep sau 15 phút không dùng.

**Q: Cần train model lại sau khi deploy không?**
A: Không, model được train local và commit vào Git. Render sẽ sử dụng model từ Git.

**Q: Làm sao update model mới?**
A: Train model mới, commit vào Git, Render sẽ tự động redeploy.

**Q: Có thể dùng database cho tracker store không?**
A: Có, cấu hình trong `endpoints.yml` với Redis hoặc MongoDB (cần service riêng).

---

Chúc bạn deploy thành công! 🎉

