# Git + GitHub 核心概念大串讲：从零到一全攻略

> **作者：** 技术爬爬虾 TechShrimp  
> **视频链接：** [https://youtu.be/bWUUHBVg-7E](https://youtu.be/bWUUHBVg-7E)  
> **来源：** 东方战忽局投稿群用户分享

---

## 一、前言

Git 是目前世界上最先进的**分布式版本控制系统**，而 GitHub 是基于 Git 的**代码托管平台**。本教程从零开始，带你掌握 Git 的核心概念与 GitHub 的远程协作流程。

---

## 二、Git 核心概念

### 1. 仓库（Repository）

仓库是 Git 用来存储项目文件及其历史记录的地方。分为：

- **本地仓库（Local Repository）**：在你的电脑上
- **远程仓库（Remote Repository）**：托管在 GitHub/GitLab 等平台

### 2. 提交（Commit）

Commit 是 Git 的核心操作，相当于**快照**。每次提交都会记录文件的完整状态，并生成一个唯一的 SHA-1 哈希值。

```
git commit -m "提交说明"
```

**最佳实践：** 提交说明要简洁明了，说明"做了什么"和"为什么做"。

### 3. 分支（Branch）

分支让你可以在不影响主代码的情况下进行开发。

- **main / master**：默认主分支
- **feature branch**：功能开发分支
- **bugfix branch**：修复 bug 分支

```
git branch <branch-name>    # 创建分支
git checkout <branch-name>  # 切换分支
git switch <branch-name>    # 切换分支（新版）
```

### 4. 合并（Merge）

将不同分支的修改合并到一起。

```
git merge <branch-name>
```

### 5. 暂存区（Staging Area / Index）

介于工作目录和仓库之间的中间区域。文件修改后需要先 `git add` 到暂存区，再 `git commit`。

```
工作目录 → git add → 暂存区 → git commit → 本地仓库
```

### 6. HEAD 指针

HEAD 是一个指向当前所在分支最新提交的指针，用来标记"当前位置"。

---

## 三、Git 常用命令实操

### 3.1 初始化与配置

```bash
# 配置用户名和邮箱（第一次使用 Git 必须设置）
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 初始化新仓库
git init

# 克隆远程仓库
git clone <repository-url>
```

### 3.2 基本操作

```bash
# 查看仓库状态
git status

# 添加文件到暂存区
git add <file>          # 添加单个文件
git add .               # 添加所有变更
git add -A              # 添加所有（包括删除）

# 提交到本地仓库
git commit -m "提交信息"

# 查看提交历史
git log                 # 完整历史
git log --oneline       # 简洁版
git log --graph         # 图形化显示分支
```

### 3.3 分支操作

```bash
# 创建并切换分支
git branch <branch-name>
git switch <branch-name>

# 或一步到位
git switch -c <branch-name>

# 查看分支
git branch              # 本地分支
git branch -a           # 所有分支（含远程）

# 合并分支（先切到目标分支）
git switch main
git merge <branch-name>

# 删除分支
git branch -d <branch-name>    # 本地删除
git branch -D <branch-name>    # 强制删除
```

### 3.4 查看差异

```bash
# 查看工作区 vs 暂存区的差异
git diff

# 查看暂存区 vs 最新提交的差异
git diff --staged

# 查看两个分支的差异
git diff <branch1>..<branch2>
```

### 3.5 撤销与回退

```bash
# 撤销工作区的修改（未 add）
git restore <file>

# 撤销暂存区的修改（已 add）
git restore --staged <file>

# 回退到某个提交（保留修改）
git reset --soft <commit-hash>

# 回退到某个提交（丢弃修改）
git reset --hard <commit-hash>
```

---

## 四、GitHub 远程仓库管理

### 4.1 连接远程仓库

```bash
# 添加远程仓库
git remote add origin <repository-url>

# 查看远程仓库
git remote -v

# 推送到远程仓库
git push -u origin main    # 首次推送（-u 建立跟踪关系）
git push                   # 后续推送
```

### 4.2 从远程拉取

```bash
# 拉取远程更新（fetch + merge）
git pull

# 只获取远程更新，不自动合并
git fetch
```

> **pull vs fetch 的区别：**  
> - `git pull` = `git fetch` + `git merge`，直接合并到当前分支  
> - `git fetch` 只下载远程数据，需要手动 `git merge` 或 `git rebase`

### 4.3 SSH 密钥配置（推荐）

```bash
# 生成 SSH 密钥
ssh-keygen -t ed25519 -C "your.email@example.com"

# 查看公钥
cat ~/.ssh/id_ed25519.pub
```

将公钥添加到 GitHub → Settings → SSH and GPG keys → New SSH key

### 4.4 .gitignore 文件

忽略不需要跟踪的文件（日志、依赖包、编译产物等）：

```gitignore
# Node.js
node_modules/

# Python
__pycache__/
*.pyc

# 系统文件
.DS_Store
Thumbs.db

# 环境变量
.env
```

---

## 五、从零到一的项目协作流程

### 5.1 单人工作流程

```bash
# 1. 创建或克隆仓库
git clone <repo-url>
cd <repo-name>

# 2. 创建功能分支
git switch -c feature-login

# 3. 开发、暂存、提交
# ... 修改代码 ...
git add .
git commit -m "实现登录功能"

# 4. 合并到主分支
git switch main
git merge feature-login

# 5. 推送到远程
git push
```

### 5.2 多人协作流程（推荐）

#### 方式一：功能分支 + Pull Request

1. **创建功能分支**
   ```bash
   git switch -c feature-xxx
   ```

2. **开发并提交**
   ```bash
   git add .
   git commit -m "完成 xxx 功能"
   ```

3. **推送到远程**
   ```bash
   git push -u origin feature-xxx
   ```

4. **在 GitHub 上创建 Pull Request（PR）**
   - 提交 PR → 代码审查 → 讨论修改 → 合并

5. **合并后删除远程分支**

#### 方式二：Fork + Pull Request（开源项目）

1. Fork 原仓库到自己的 GitHub 账号
2. Clone 自己的 Fork
3. 添加原仓库为上游（upstream）
   ```bash
   git remote add upstream <原仓库URL>
   ```
4. 创建功能分支开发
5. 提交 PR 到原仓库

### 5.3 常见冲突解决

当两个人修改了同一个文件的同一区域时，Git 会产生冲突：

```bash
# 合并时发生冲突
git merge feature-branch
# 输出：CONFLICT (content): Merge conflict in xxx.txt
```

**解决步骤：**

1. 打开冲突文件，找到冲突标记：
   ```
   <<<<<<< HEAD
   你的修改
   =======
   对方的修改
   >>>>>>> feature-branch
   ```

2. 手动选择保留的内容，删除冲突标记

3. 标记为已解决并提交：
   ```bash
   git add .
   git commit -m "解决合并冲突"
   ```

---

## 六、进阶技巧

### 6.1 Rebase（变基）

Rebase 让你的提交历史更整洁，避免多余的 merge commit。

```bash
# 将当前分支的修改"移植"到目标分支的最新提交之后
git switch feature-branch
git rebase main

# 交互式 rebase（整理提交历史）
git rebase -i HEAD~3
```

> ⚠️ **注意：** 不要对已推送到远程的分支做 rebase，会改写历史！

### 6.2 Stash（暂存）

临时保存当前工作区的修改，切换到其他分支工作。

```bash
git stash              # 暂存当前修改
git stash list         # 查看暂存列表
git stash pop          # 恢复最近一次暂存
git stash drop         # 删除最近一次暂存
```

### 6.3 Cherry-pick（精选提交）

将某个分支的特定提交应用到当前分支。

```bash
git cherry-pick <commit-hash>
```

### 6.4 Tag（标签）

为重要的提交打标签，常用于版本发布。

```bash
git tag v1.0.0
git tag -a v1.0.0 -m "正式版 v1.0.0"
git push --tags
```

---

## 七、GitHub 实用功能

| 功能 | 说明 |
|------|------|
| **Issues** | 任务跟踪、Bug 报告、功能请求 |
| **Pull Requests** | 代码审查与合并 |
| **Actions** | CI/CD 自动化流水线 |
| **Projects** | 看板式项目管理 |
| **Wiki** | 项目文档 |
| **GitHub Pages** | 静态网站托管 |
| **Code Review** | 逐行代码审查与评论 |

---

## 八、最佳实践总结

1. ✅ **频繁提交**：小步快跑，每次提交一个完整的功能点
2. ✅ **写清晰的提交信息**：说明"为什么"而非"是什么"
3. ✅ **分支策略**：永远不要在 main 上直接开发
4. ✅ **及时拉取**：每天开始工作前先 `git pull`
5. ✅ **代码审查**：提交 PR 后请同事审查
6. ❌ **不要 rebase 已推送的分支**
7. ❌ **不要提交敏感信息**（密码、Token、密钥）
8. ❌ **不要直接提交到 main**

---

## 九、快速参考卡片

```bash
# 初始化
git init                    # 新建仓库
git clone <url>             # 克隆仓库

# 日常操作
git status                  # 查看状态
git add .                   # 暂存所有
git commit -m "msg"         # 提交
git push                    # 推送
git pull                    # 拉取

# 分支
git branch                  # 查看分支
git switch -c <name>        # 新建并切换
git merge <name>            # 合并分支

# 查看历史
git log --oneline --graph   # 查看提交图
git diff                    # 查看差异

# 撤销
git restore <file>          # 撤销修改
git reset --hard HEAD       # 回退到最新提交
```

---

> **视频教程：** [技术爬爬虾 TechShrimp - Git+Github核心概念大串讲](https://youtu.be/bWUUHBVg-7E)  
> **来源：** 东方战忽局投稿群用户分享  
> **建议：** 本教程配合视频学习效果更佳，动手实践是掌握 Git 的最佳方式！
