# 🔍 Debug Deploy Failed

## ✅ Đã sửa:

1. **Bỏ `plan: free`**: Render sẽ tự động dùng free plan nếu không chỉ định
2. **Có thể lỗi do train model quá lâu**: Free plan có giới hạn build time

## 🔍 Các bước debug:

### 1. Kiểm tra Logs trên Render:

Vào mỗi service → Tab **"Logs"** để xem lỗi cụ thể:

**Lỗi thường gặp:**
- `Build timeout` → Train model quá lâu
- `Module not found` → Thiếu dependencies
- `Port already in use` → Lỗi start command
- `No model found` → Model chưa được train

### 2. Nếu lỗi "Build timeout":

**Giải pháp**: Tách train model ra khỏi build command

Cập nhật `render.yaml`:
```yaml
buildCommand: pip install -r requirements.txt
```

Sau đó train model trong start command hoặc tạo script riêng.

### 3. Nếu lỗi "No model found":

**Giải pháp**: Train model trước khi start

Cập nhật `render.yaml`:
```yaml
buildCommand: pip install -r requirements.txt && rasa train
startCommand: rasa run --enable-api --cors "*" --port $PORT
```

### 4. Nếu lỗi dependencies:

Kiểm tra `requirements.txt` có đầy đủ không.

---

## 🛠️ Giải pháp tạm thời:

### Option 1: Train model local và push lên (tạm thời)

```bash
# Train model local
rasa train

# Tạm thời bỏ ignore model
git add -f models/*.tar.gz
git commit -m "Add model for deployment"
git push
```

Sau đó cập nhật `render.yaml`:
```yaml
buildCommand: pip install -r requirements.txt
# Bỏ rasa train
```

### Option 2: Tăng build timeout

Upgrade lên Starter plan ($7/tháng) để có build timeout dài hơn.

---

## 📝 Checklist debug:

1. [ ] Vào service → Logs → Xem lỗi cụ thể
2. [ ] Copy lỗi và tìm giải pháp
3. [ ] Kiểm tra buildCommand có đúng không
4. [ ] Kiểm tra startCommand có đúng không
5. [ ] Kiểm tra requirements.txt
6. [ ] Thử train model local trước

---

## 💡 Tips:

- **Free plan build timeout**: ~10-15 phút
- **Train model 100 epochs**: Có thể mất 5-10 phút
- **Nếu timeout**: Train model local và push lên

