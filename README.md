# Minecraft Java Edition Server Launcher Powered By Powershell
## 配置运行环境
配置Windows PowerShell以允许运行`.ps1`脚本文件

---

### **步骤 1：以管理员身份打开 PowerShell**
- **Windows 10/11**：右键点击开始菜单按钮 → 选择 **Windows PowerShell (管理员)** 或 **终端 (管理员)**。
- **验证管理员权限**：确保窗口标题栏显示“管理员”字样。

---

### **步骤 2：修改执行策略（Execution Policy）**
PowerShell默认阻止脚本运行，需调整执行策略：
```powershell
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine
```
- **RemoteSigned**：允许运行本地脚本，远程脚本需数字签名（推荐平衡安全与灵活性）。
- **其他选项**：
  - `Unrestricted`：允许所有脚本（有风险）。
  - `AllSigned`：仅允许受信任签名的脚本。
- **作用域**：
  - `-Scope LocalMachine`（需管理员权限，影响所有用户）。
  - `-Scope CurrentUser`（仅当前用户，无需管理员权限）。

---

### **步骤 3：验证执行策略**
查看当前策略：
```powershell
Get-ExecutionPolicy
```
确认输出为 `RemoteSigned` 或你设置的策略。

---

### **步骤 4：运行脚本**
1. **导航到脚本目录**：
   ```powershell
   cd %userprofile%\Downloads\
   ```
2. **执行脚本**：
   ```powershell
   .\run-pwsh.ps1
   ```
   - 若脚本被阻止（网络下载），使用：
     ```powershell
     Unblock-File -Path .\run-pwsh.ps1
     ```