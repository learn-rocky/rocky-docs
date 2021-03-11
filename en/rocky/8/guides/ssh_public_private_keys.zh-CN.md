＃Rocky Linux-SSH公钥和私钥

##先决条件

*从命令行运行一定程度的舒适感
*安装了* openssh *的Rocky Linux服务器和/或工作站
*从技术上讲，此过程可以在安装了openssh的任何Linux系统上运行
*可选：熟悉linux文件和目录权限

＃ 介绍

SSH是一种协议，通常用于通过命令行从另一台计算机访问另一台计算机。使用SSH，您可以在远程计算机和服务器上运行命令，发送文件，并通常从一个地方管理您所做的一切。

当您在多个位置使用多个Rocky Linux服务器时，或者如果您只是想节省访问这些服务器的时间，则需要使用SSH公钥和私钥对。密钥对从根本上使登录远程计算机和运行命令更加容易。

本文档将指导您完成使用上述密钥创建密钥和设置服务器以方便访问的过程。

###生成密钥的过程

以下命令全部在您的Rocky Linux工作站上的命令行中执行：

`ssh-keygen -t rsa`

将显示以下内容：

```
生成公共/私有rsa密钥对。
输入要在其中保存密钥的文件（/root/.ssh/id_rsa）：
```

点击Enter接受默认位置。接下来，系统将显示：

输入密码（无密码时为空）：

因此，只需点击Enter。最后，它将要求您重新输入密码：

再次输入相同的密码：

因此，请按Enter输入最后的时间。

您现在应该在.ssh目录中具有RSA类型的公钥和私钥对：

```
ls -a .ssh /
。 .. id_rsa id_rsa.pub
```

现在，我们需要将公钥（id_rsa.pub）发送到我们将要访问的每台计算机...但是在执行此操作之前，我们需要确保可以将SSH SSH到将要发送的服务器上。关键。对于我们的示例，我们将仅使用三台服务器。

您可以使用DNS名称或IP地址通过SSH访问它们，但是在我们的示例中，我们将使用DNS名称。我们的示例服务器是Web，邮件和门户。对于每台服务器，我们将尝试SSH（书呆子喜欢将SSH作为动词使用），并为每台计算机打开终端窗口：

ssh -l root web.ourourdomain.com

假设我们可以在所有三台计算机上顺利登录，那么下一步就是将我们的公钥发送到每个服务器：

scp .ssh / id_rsa.pub root@web.ourourdomain.com：/ root /

对我们的三台机器中的每一个重复此步骤。

在每个打开的终端窗口中，当您输入以下命令时，现在应该可以看到* id_rsa.pub *：

`ls -a | grep id_rsa.pub`

如果是这样，我们现在准备在每个服务器的* .ssh *目录中创建或添加* authorized_keys *文件。在每台服务器上，输入以下命令：

ls -a .ssh

**重要的！请确保您仔细阅读以下所有内容。如果不确定是否会破坏某些内容，请在每台计算机上制作一个authorized_keys（如果存在）的备份副本，然后继续。**

如果没有列出* authorized_keys *文件，那么我们将在_ / root_目录中输入以下命令来创建该文件：

`cat id_rsa.pub> .ssh / authorized_keys`

如果_authorized_keys_确实存在，那么我们只想将我们的新公钥附加到已经存在的公钥中：

`cat id_rsa.pub >> .ssh / authorized_keys`

将密钥添加到_authorized_keys_或创建_authorized_keys_文件后，尝试再次从Rocky Linux工作站到服务器进行SSH。不应提示您输入密码。

确认可以不使用密码进行SSH登录后，请从每台计算机的_ / root_目录中删除id_rsa.pub文件。

rm id_rsa.pub

### SSH目录和authorized_keys安全

在每台目标计算机上，确保应用以下权限：

chmod 700 .ssh /
chmod 600 .ssh / authorized_keys



