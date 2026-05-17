# Ghi chú cài đặt — Fullstack Marketing Skills

## Lệnh đã chạy

```bash
bash install.sh --global
```

## Kết quả

- **Destination:** `~/.claude/skills/marketing/`
- **Số file cài:** 35 file `.md`
- **Skill:** 21 skill (00 → 19) + `product-marketing-context`
- **Kèm theo:** `agents/`, `references/`, `workflows/`, `CLAUDE.md`
- **Validation:** 10 PASS · 11 WARN · 0 Issue

## Sử dụng trong Claude Code

```
Lập kế hoạch marketing cho [sản phẩm]
Viết script TikTok cho [sản phẩm]
Đánh giá hiệu suất chiến dịch [tên]

/skill product-marketing-context
/skill 00-ke-hoach-mkt
```

## Lưu ý

Session này chạy trên remote container. Nếu cần dùng lâu dài trên máy local:

```bash
git clone https://github.com/minhnv0807/fullstack-mkt-skills
cd fullstack-mkt-skills
bash install.sh --global
```
