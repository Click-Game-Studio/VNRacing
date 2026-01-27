# 💡 BRIEF: AI Agent Integration cho VNRacing Team (Updated)

**Ngày tạo:** 2026-01-21
**Brainstorm cùng:** Phan (Team Lead)
**Project:** VNRacing - Unreal Engine 5.4+ Mobile Racing Game

---

## 1. VẤN ĐỀ CẦN GIẢI QUYẾT

### 🎯 Thách thức chính
- **Context Fragmentation:** Knowledge rải rác (C++, BP, Docs).
- **Blueprint Opacity:** AI không hiểu visual scripts.
- **Cost Concern:** Cần giải pháp tối ưu chi phí nhưng vẫn hiệu quả.

### 📊 Asset hiện có
- Docs structure chuẩn (`Docs/`, `GDD`, `Standards`).
- Source code C++ & Blueprints.

---

## 2. GIẢI PHÁP ĐỀ XUẤT (Finalized Stack)

### 🏗️ Recommended Architecture: "Zero-Cost Local RAG"

```mermaid
graph TD
    subgraph "Local Infrastructure (Free)"
        Ollama[Ollama Server<br/>(Embeddings + LLM)]
        Milvus[Milvus Lite<br/>(Vector DB)]
        Memgraph[Memgraph<br/>(Knowledge Graph)]
    end

    subgraph "Context Sources"
        CPP[C++ Source] -->|Tree-sitter| Memgraph
        Docs[Docs Folder] -->|LangChain| Milvus
        BP[Blueprints] -->|BP2AI Export| Milvus
    end

    subgraph "AI Clients"
        Cursor[Cursor IDE]
        Claude[Claude Code / MCP Client]
        Continue[Continue.dev Plugin]
    end

    Milvus --> Cursor
    Milvus --> Continue
    Memgraph --> Claude
    
    style Ollama fill:#4CAF50,stroke:#333
    style Milvus fill:#4CAF50,stroke:#333
    style Memgraph fill:#2196F3,stroke:#333
```

### 🔧 Key Components

#### 1. RAG Core (Free & Self-Hosted)
- **Vector DB:** **Milvus Lite** (chạy local file, không cần Docker complex).
- **Embeddings:** **Ollama** (`mxbai-embed-large` hoặc `nomic-embed-text`).
- **Knowledge Graph:** **Memgraph** (cho deep code understanding).

#### 2. Auto-Update Mechanism
- **Trigger:** **Git Post-Commit Hook** (Local MVP) & **GitHub Actions** (Team scale).
- **Logic:** Incremental indexing dựa trên file hash (chỉ process file thay đổi).
- **Blueprint:** Batch export via UE Python script (headless).

#### 3. Blueprint Integration
- **Tool:** Custom Python script sử dụng Unreal Python API hoặc **BP2AI plugin** ($35 - recommended for speed).
- **Flow:** `.uasset` -> `Headless UE` -> `Markdown` -> `Vector DB`.

---

## 3. LỘ TRÌNH TRIỂN KHAI (Updated)

### 🚀 Phase 1: Quick Wins (Week 1 - Free Stack)
> **Goal:** Team dùng được ngay Documentation RAG trong IDE.

1. **Setup Continue.dev**: Install extension, config Ollama embeddings.
2. **Index `Docs/`**: Chạy script index docs folder vào local index của Continue.
3. **Value:** Dev có thể hỏi "Quy tắc đặt tên biến là gì?" ngay trong VSCode.

### 🛠️ Phase 2: Deep Code Integration (Week 2-3)
> **Goal:** AI hiểu cấu trúc C++ và relationships.

1. **Deploy `code-graph-rag`**: Fork repo `vitali87/code-graph-rag`.
2. **Parse C++ Source**: Build knowledge graph cho folder `Source/`.
3. **Setup MCP**: Connect Claude Desktop/Cursor với MCP server của graph RAG.

### 🤖 Phase 3: Blueprint & Automation (Week 4+)
> **Goal:** Full automation và Blueprint support.

1. **Blueprint Export**: Implement headless export script.
2. **Auto-Update**: Setup CI/CD pipeline để auto-reindex khi push code.

---

## 4. CÔNG CỤ & REPO KHẢO SÁT

| Repo / Tool | Vai trò | Trạng thái | Ghi chú |
|-------------|---------|------------|---------|
| **vitali87/code-graph-rag** | Core Engine | ✅ Highly Recommended | Native C++ support, Knowledge graph, MCP ready |
| **Continue.dev** | IDE Client | ✅ Recommended | Dễ setup, free, hỗ trợ RAG docs tốt |
| **Aider** | Coding Agent | ⚠️ Optional | Tốt cho terminal-based coding, không có MCP |
| **LangChain** | Custom Pipeline | ⚠️ Backup | Chỉ dùng nếu cần custom logic phức tạp |

---

## 5. NEXT STEPS

1. **Confirm Stack:** Chốt phương án **Milvus + Ollama + code-graph-rag**.
2. **Pilot:** Em sẽ setup thử nghiệm **Continue.dev** với `Docs/` folder trước.
3. **Prepare:** User chuẩn bị environment (cài Ollama, pull model).

---

**Summary:** Giải pháp đã chuyển sang hướng **Self-hosted & Free** tối đa, tận dụng các open-source tools mạnh nhất hiện nay (Ollama, Milvus, code-graph-rag) để giải quyết bài toán context fragmentation của VNRacing team.
