关于工程项目远程托管信息如下：
根目录下的ComfyUI项目，需要远程托管到github上，项目名称为ComfyUI，项目地址为https://github.com/comfyanonymous/ComfyUI.git

models目录下的模型文件，不需要进行提交，因为模型文件比较大，提交会占用很多空间，同时也会影响到项目的下载速度。
custom_nodes目录下的文件，也不需要进行提交，因为custom_nodes目录下的文件为自定义节点的代码，这些代码都是根据个人需求进行修改的，不会影响到项目的正常运行。
custom_nodes下custom_nodes/comfyui-manager 项目源代码托管地址为https://github.com/ltdrdata/ComfyUI-Manager.git,二次开发地址为：git@github.com:lastrye/ComfyuiPkgTools.git。前者为后者的upstream
web_source目录下的文件为comfyui front的代码，源代码托管地址：https://github.com/Comfy-Org/ComfyUI_frontend.git

要求，Fork 与 rebase 配合使用，在与源代码库保持同步的同时，建立自己的开发版本，用于个人二次开发和测试。 请给出git提交策略
如果源代码和二次开发版本的代码有冲突，需要手动解决冲突。给出具体命令示例。
注意.gitignore 还有 web_source/.gitignore 均给出忽略的信息。
已知：1）https://github.com/comfyanonymous/ComfyUI.git的 fork地址 https://github.com/lastrye/AGIFlowUI.git；或者 git@github.com:lastrye/AGIFlowUI.git
2）https://github.com/ltdrdata/ComfyUI-Manager.git的 Fork地址为：git@github.com:lastrye/ComfyuiPkgTools.git；
3）https://github.com/Comfy-Org/ComfyUI_frontend.git的 Fork地址为：git@github.com:lastrye/ComfyWebUI.git

具体操作策略如下：

### 1. Git 仓库配置策略

本项目涉及三个独立的 Git 仓库，分别位于根目录、`web_source` 和 `custom_nodes/comfyui-manager`。

#### 1.1 根目录 (ComfyUI)
- **目录**: `/run/media/lastrye/Dev/AIGC/ComfyUI/ComfyUI`
- **默认分支**: `master`
- **Upstream (官方源)**: `https://github.com/comfyanonymous/ComfyUI.git`
- **Origin (你的 Fork)**: `git@github.com:lastrye/AGIFlowUI.git`
- **忽略策略 (`.gitignore`)**:
    - `models/`: 忽略大文件。
    - `custom_nodes/`: 忽略自定义节点目录（`comfyui-manager` 单独管理）。
    - `web_source/`: 忽略前端源码目录（单独管理）。
    - *配置命令示例*:
      ```bash
      # 确保在根目录
      git remote add upstream https://github.com/comfyanonymous/ComfyUI.git
      git remote set-url origin git@github.com:lastrye/AGIFlowUI.git
      ```

#### 1.2 ComfyUI Manager
- **目录**: `custom_nodes/comfyui-manager`
- **默认分支**: `main`
- **Upstream (官方源)**: `https://github.com/ltdrdata/ComfyUI-Manager.git`
- **Origin (你的 Fork)**: `git@github.com:lastrye/ComfyuiPkgTools.git`
- **忽略策略**: 遵循该项目自带的 `.gitignore`。
- **配置命令示例**:
  ```bash
  cd custom_nodes/comfyui-manager
  git remote add upstream https://github.com/ltdrdata/ComfyUI-Manager.git
  git remote set-url origin git@github.com:lastrye/ComfyuiPkgTools.git
  ```

#### 1.3 ComfyUI Frontend (web_source)
- **目录**: `web_source`
- **默认分支**: `main`
- **Upstream (官方源)**: `https://github.com/Comfy-Org/ComfyUI_frontend.git`
- **Origin (你的 Fork)**: `git@github.com:lastrye/ComfyWebUI.git`
- **忽略策略**: 遵循该项目自带的 `.gitignore` (已包含 `node_modules`, `dist` 等)。
- **配置命令示例**:
  ```bash
  cd web_source
  git remote add upstream https://github.com/Comfy-Org/ComfyUI_frontend.git
  git remote set-url origin git@github.com:lastrye/ComfyWebUI.git
  ```

### 2. 同步与开发流程 (Fork & Rebase)

为了保持与上游代码同步，同时维护自己的修改，统一使用 **Rebase** 策略。

#### 2.1 同步上游代码
每次开始开发前，或定期同步上游代码：

```bash
# 1. 获取上游最新代码
git fetch upstream

# 2. 将本地分支重基到上游分支
# --- 对于 ComfyUI (根目录) ---
git checkout master
git rebase upstream/master

# --- 对于 ComfyUI Manager 和 Frontend ---
# git checkout main
# git rebase upstream/main
```

#### 2.2 提交更改到自己的 Fork
```bash
# 推送更改到 origin
# 如果 rebase 改变了历史（例如上游有新提交），可能需要强制推送
git push origin master
# 或者更安全的强制推送
git push origin master --force-with-lease
```
*(注意：对应其他仓库请使用 `main` 分支)*

### 3. 冲突解决策略

当 `git rebase` 遇到冲突时，流程如下：

1.  **识别冲突**: 终端会提示冲突的文件 (CONFLICT)。
2.  **手动解决**: 使用编辑器打开冲突文件，查找 `<<<<<<<`，`=======`，`>>>>>>>` 标记。
    - `<<<<<<< HEAD`: 你的修改
    - `=======`: 分隔符
    - `>>>>>>> upstream/master`: 上游的修改
    - **操作**: 保留需要的代码，删除冲突标记。
3.  **标记解决**:
    ```bash
    git add <conflicted_file>
    ```
4.  **继续 Rebase**:
    ```bash
    git rebase --continue
    ```
5.  **如果搞砸了，中止 Rebase**:
    ```bash
    git rebase --abort
    ```

### 4. 忽略文件配置说明

#### 根目录 `.gitignore` 关键配置
```gitignore
# 忽略模型文件
/models/

# 忽略自定义节点 (因为 comfyui-manager 是独立仓库，其他节点也需忽略)
/custom_nodes/
!custom_nodes/example_node.py.example

# 忽略前端源码 (独立仓库)
/web_source/

# 其他常规忽略
__pycache__/
*.py[cod]
/output/
/input/
.venv/
```

#### `web_source/.gitignore` 关键配置
确保包含以下内容（通常项目已自带）：
```gitignore
node_modules
dist
.env
logs
```

### 5. 私有二次开发维护指南（仅自用，不合并回官方）

如果你只是想在官方代码的基础上添加自己的功能供个人使用，而不需要将代码贡献回官方仓库，请遵循以下策略：

#### 5.1 核心原则：始终基于最新官方版本 (Always on top)
为了既能享受到官方的新功能和 Bug 修复，又能保留你的个性化修改，最佳做法是让你的提交始终“浮”在官方提交之上。

#### 5.2 推荐操作流程
依然使用 **Rebase** 工作流，这是维护私有定制版最干净的方式。

1.  **拉取官方最新代码**：
    ```bash
    git fetch upstream
    ```
2.  **将你的修改“重放”在官方最新代码之后**：
    ```bash
    git rebase upstream/master
    # 如果是 web_source 或 manager，请使用 upstream/main
    ```
    *此时，Git 会先撤销你的修改，更新到底层最新版，然后再把你的修改一条条应用上去。*

3.  **处理可能出现的冲突**：
    *   由于官方代码变动，可能会与你的修改冲突。
    *   按照第 3 节的“冲突解决策略”手动修复。
    *   *提示：既然不回馈官方，解决冲突时可以大胆保留你的逻辑，或者适配官方的新架构。*

4.  **强制更新你的远程仓库**：
    因为 Rebase 修改了提交历史，必须使用强制推送更新你自己的 GitHub 仓库：
    ```bash
    git push origin master --force-with-lease
    ```

#### 5.3 注意事项
1.  **永远不要 `git push upstream`**：你通常没有权限，但要确保配置正确以免误报错误。
2.  **谨慎修改核心文件**：修改的文件越核心（如 `execution.py` 或 `nodes.py` 的基础逻辑），官方更新时冲突的概率越大。尽量通过编写 Custom Nodes 来扩展功能，而不是直接修改核心代码。
3.  **定期同步**：不要积攒太久才同步一次。由于 ComfyUI 更新频繁，积攒太久的更新会导致 Rebase 时的冲突难以处理（Conflict Hell）。建议每周或每次官方发布大版本时同步一次。
4.  **分支备份（后悔药）**：
    在执行 Rebase 这种破坏性操作前，建议先备份当前分支：
    ```bash
    git branch backup-before-rebase
    ```
    如果 Rebase 搞砸了，可以随时恢复：
    ```bash
    git reset --hard backup-before-rebase
    ```

### 6. Git 原理深度解析：为什么选 Rebase？

为了让你更安心地执行这些命令，我们需要理解 Git 底层发生了什么。

#### 6.1 提交链与指针
想象 Git 的提交历史是一串珍珠项链，每一颗珍珠（Commit）都指向上一个珍珠（Parent）。
*   **分支（Branch）**：仅仅是一个贴在某颗珍珠上的标签（指针）。
*   **HEAD**：是你当前正在看的珍珠。

#### 6.2 场景模拟：分叉的产生
1.  **初始状态**：你和官方都在 `C2` 节点。
    ```text
    C1 <- C2 (upstream/master, your-master)
    ```
2.  **各自发展**：
    *   官方更新了 `C3`, `C4`。
    *   你开发了私有功能 `My1`。
    *   执行 `git fetch` 后，本地图景变成了**分叉**状：
    ```text
          (upstream/master)
             |
             v
       /--- C3 <- C4
    C2 
       \--- My1
             ^
             |
        (your-master)
    ```

#### 6.3 Merge vs Rebase 的本质区别

**方案 A: Merge (合并)**
如果你执行 `git merge upstream/master`，Git 会创建一个新的“合并节点” `M`。
```text
       /--- C3 <- C4 --\
    C2                  M  <- (your-master)
       \--- My1 -------/
```
*   **结果**：历史线变成菱形（分叉再汇合）。
*   **缺点**：如果你每周同步一次，一年后你的历史线会变成乱糟糟的“麻花”，难以看清你的功能到底改了什么。

**方案 B: Rebase (变基) —— 我们要用的策略**
如果你执行 `git rebase upstream/master`，Git 会做三件事：
1.  **剪切**：把你的 `My1` 暂时拿下来，保存为补丁。
2.  **移动**：把你的基底从 `C2` 挪到最新的 `C4`。
3.  **重放**：把 `My1` 重新应用在 `C4` 后面，生成一个新的 `My1'`。

```text
                    (upstream/master)
                           |
                           v
    C1 <- C2 <- C3 <- C4 <- My1'
                               ^
                               |
                          (your-master)
```
*   **结果**：历史线是一条完美的直线。
*   **优势**：逻辑上，这等同于“我在官方最新的代码上，重新写了一遍我的功能”。

#### 6.4 为什么需要强制推送 (Force Push)？
看上面的 Rebase 结果图，你的本地分支变成了 `... C4 <- My1'`。
但是，你 GitHub 上的远程仓库（origin）还停留在旧状态：`... C2 <- My1`。

*   **冲突**：Git 发现 `My1'` 和 `My1` 是两个完全不同的提交（虽然代码逻辑一样，但父节点不同，Hash 就不同）。
*   **拒绝**：默认的 `git push` 会报错，因为它觉得你把 `My1` 弄丢了。
*   **解决**：`--force` (或 `--force-with-lease`) 的意思是：“**别管旧的 `My1` 了，把它丢掉，把远程仓库的指针直接硬拽到 `My1'` 这里来**”。

这就是为什么 Rebase 工作流必须配合 Force Push 的原因。