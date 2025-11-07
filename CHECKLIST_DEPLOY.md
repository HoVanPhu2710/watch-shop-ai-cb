# ✅ Checklist: Files cần push lên GitHub để deploy

## 📦 Files BẮT BUỘC phải push:

### ✅ Core Rasa Files:
- [x] `config.yml` - Cấu hình Rasa pipeline và policies
- [x] `domain.yml` - Domain definition (intents, entities, responses)
- [x] `endpoints.yml` - Endpoint configuration (đã có sẵn biến môi trường)
- [x] `credentials.yml` - Credentials (nếu cần)

### ✅ Training Data:
- [x] `data/nlu.yml` - NLU training data
- [x] `data/stories.yml` - Conversation stories
- [x] `data/rules.yml` - Conversation rules

### ✅ Custom Actions:
- [x] `actions/__init__.py`
- [x] `actions/actions.py` - **Đã cập nhật với API_BASE_URL**

### ✅ Dependencies & Config:
- [x] `requirements.txt` - Python dependencies
- [x] `runtime.txt` - Python version (optional nhưng nên có)

### ✅ Deployment Files:
- [x] `render.yaml` - **QUAN TRỌNG!** File cấu hình Render Blueprint
- [x] `Procfile` - Cho Heroku/Railway (optional)
- [x] `README_DEPLOY.md` - Hướng dẫn deployment
- [x] `DEPLOY_GUIDE.md` - Hướng dẫn chi tiết

### ✅ Other:
- [x] `.gitignore` - Đảm bảo ignore đúng files

---

## ❌ Files KHÔNG cần push (đã được ignore):

- ❌ `models/` - Model sẽ được train tự động trên Render
- ❌ `rasaenv/` - Virtual environment (Render tự tạo)
- ❌ `.rasa/` - Cache files
- ❌ `*.log` - Log files
- ❌ `__pycache__/` - Python cache

---

## 🔍 Kiểm tra trước khi push:

```bash
# 1. Kiểm tra git status
git status

# 2. Xem files sẽ được commit
git status --short

# 3. Kiểm tra .gitignore có đúng không
cat .gitignore | grep -E "(models|rasaenv)"

# 4. Test local trước (optional)
.\rasaenv\Scripts\Activate.ps1
rasa train
rasa run --enable-api --cors "*" --port 5005
```

---

## 📝 Lệnh push:

```bash
# Thêm tất cả files cần thiết
git add render.yaml
git add Procfile
git add runtime.txt
git add README_DEPLOY.md
git add DEPLOY_GUIDE.md
git add CHECKLIST_DEPLOY.md
git add actions/actions.py
git add endpoints.yml

# Commit
git commit -m "Add Render deployment configuration and update actions for cloud"

# Push lên GitHub
git push origin main
```

---

## ⚠️ Lưu ý quan trọng:

1. **Model không cần push**: Render sẽ tự động train model khi deploy (đã cập nhật `render.yaml` với `rasa train`)

2. **Virtual environment không cần push**: Render sẽ tự tạo venv mới khi deploy

3. **Đảm bảo `.gitignore` đúng**: Kiểm tra xem `models/` và `rasaenv/` đã được ignore chưa

4. **Test local trước**: Nên test train và run local trước khi deploy để đảm bảo không có lỗi

---

## 🎯 Sau khi push:

1. Vào Render Dashboard
2. Tạo Blueprint từ GitHub repository
3. Render sẽ tự động:
   - Đọc `render.yaml`
   - Tạo 2 services
   - Cài dependencies
   - **Train model tự động** (nhờ buildCommand đã cập nhật)
   - Deploy services

