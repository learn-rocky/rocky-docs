# Rocky Linux-SSH公鑰和私鑰

## 先決條件

* 從命令行運行一定程度的舒適感
* 安裝了* openssh *的Rocky Linux服務器和/或工作站
* 從技術上講，此過程可以在安裝了openssh的任何Linux系統上運行
* 可選：熟悉linux文件和目錄權限

# 介紹

SSH是一種協議，通常用於通過命令行從另一台計算機訪問另一台計算機。使用SSH，您可以在遠程計算機和服務器上運行命令，發送文件，並通常從一個地方管理您所做的一切。

當您在多個位置使用多個Rocky Linux服務器時，或者如果您只是想節省訪問這些服務器的時間，則需要使用SSH公鑰和私鑰對。密鑰對從根本上使登錄遠程計算機和運行命令更加容易。

本文檔將指導您完成使用上述密鑰創建密鑰和設置服務器以方便訪問的過程。

### 生成密鑰的過程

以下命令都是從Rocky Linux工作站上的命令行執行的：

`ssh-keygen -t rsa`

將顯示以下內容：

```
生成公共/私有rsa密鑰對。
輸入要在其中保存密鑰的文件（/root/.ssh/id_rsa）：
```

點擊Enter接受默認位置。接下來，系統將顯示：

輸入密碼（無密碼時為空）：

因此，只需點擊Enter。最後，它將要求您重新輸入密碼：

再次輸入相同的密碼：

因此，請按Enter輸入最後的時間。

您現在應該在.ssh目錄中具有RSA類型的公鑰和私鑰對：

```
ls -a .ssh /
。 .. id_rsa id_rsa.pub
```

現在，我們需要將公鑰（id_rsa.pub）發送到我們將要訪問的每台計算機上……但是在執行此操作之前，我們需要確保可以將SSH SSH到將要發送的服務器上。關鍵。對於我們的示例，我們將僅使用三台服務器。

您可以使用DNS名稱或IP地址通過SSH訪問它們，但是在我們的示例中，我們將使用DNS名稱。我們的示例服務器是Web，郵件和門戶。對於每台服務器，我們將嘗試SSH（書呆子喜歡將SSH作為動詞使用），並為每台計算機打開終端窗口：

ssh -l root web.ourourdomain.com

假設我們可以在所有三台計算機上順利登錄，那麼下一步就是將我們的公鑰發送到每個服務器：

scp .ssh / id_rsa.pub root@web.ourourdomain.com：/ root /

對我們的三台機器中的每一個重複此步驟。

在每個打開的終端窗口中，當您輸入以下命令時，現在應該可以看到* id_rsa.pub *：

`ls -a | grep id_rsa.pub`

如果是這樣，我們現在準備在每個服務器的* .ssh *目錄中創建或添加* authorized_keys *文件。在每台服務器上，輸入以下命令：

ls -a .ssh

** 重要的！請確保您仔細閱讀以下所有內容。如果不確定是否會破壞某些內容，請在每台計算機上製作一個authorized_keys（如果存在）的備份副本，然後繼續。**

如果沒有列出* authorized_keys *文件，那麼我們將在_ / root_目錄中輸入以下命令來創建該文件：

`cat id_rsa.pub> .ssh / authorized_keys`

如果_authorized_keys_確實存在，那麼我們只想將我們的新公鑰附加到已經存在的公鑰中：

`cat id_rsa.pub >> .ssh / authorized_keys`

將密鑰添加到_authorized_keys_或創建_authorized_keys_文件後，嘗試再次從Rocky Linux工作站到服務器進行SSH。不應提示您輸入密碼。

確認無需密碼即可進行SSH登錄後，請從每台計算機的_ / root_目錄中刪除id_rsa.pub文件。

rm id_rsa.pub

###  SSH目錄和authorized_keys安全

在每台目標計算機上，確保應用以下權限：

chmod 700 .ssh /
chmod 600 .ssh / authorized_keys



