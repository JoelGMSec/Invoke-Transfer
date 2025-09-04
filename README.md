<p align="center"><img width=600 alt="Invoke-Transfer" src="https://github.com/JoelGMSec/Invoke-Transfer/blob/main/Invoke-Transfer.png"></p>

# Invoke-Transfer

### PowerShell Clipboard Data Transfer

Invoke-Transfer is a PowerShell tool that helps you to send files in **highly restricted environments** such as Citrix, RDP, VNC or Guacamole.  
You can send files in text format, in small **Base64 encoded chunks** or in plaintext. Additionally, you can recieve files from a screenshot, using the **native OCR function** of Microsoft Windows.


## ✨ Features

- 📋 **Clipboard-based transfer**: Send files through clipboard in restricted environments
- 🔀 **Base64 encoding**: Converts files to text format for easy and safe transfer
- ⚡ **Chunked transfer**: Split files into 120KB chunks with configurable delays
- 🖼️ **OCR support**: Read and recieve files from screenshots using Windows OCR
- 🥑 **Guacamole compatibility**: Special mode for Apache Guacamole environments
- ✏️ **Raw keystroke mode**: Send plain text (typewriter mode) with time delays
- 💻 **Windows native**: Built for Windows 10+ with PowerShell 5.1

## ⚙️ Requirements

- PowerShell 5.1
- Windows 10 or greater

Download the repository:

```bash
git clone https://github.com/JoelGMSec/Invoke-Transfer
```

## 🚀 Usage

```java
.\Invoke-Transfer.ps1 -h

  ___                 _           _____                     __
 |_ _|_ __ _   __ __ | | __ __   |_   _| __ __ _ _ __  ___ / _| ___ _ __
  | || '_ \ \ / / _ \| |/ / _ \____| || '__/ _' | '_ \/ __| |_ / _ \ '__|
  | || | | \ V / (_) |   <  __/____| || | | (_| | | | \__ \  _|  __/ |
 |___|_| |_|\_/ \___/|_|\_\___|    |_||_|  \__,_|_| |_|___/_|  \___|_|

  ----------------------- by @JoelGMSec & @3v4Si0N ---------------------

Info:  This tool helps you to send files in highly restricted environments
       such as Citrix, RDP, VNC, Guacamole... using the clipboard function

 Usage: .\Invoke-Transfer.ps1 -split {FILE} -sec {SECONDS}
          Send 120KB chunks with a set time delay of seconds
          Add -guaca to send files through Apache Guacamole

        .\Invoke-Transfer.ps1 -plain {FILE or TEXT} -sec {SECONDS}
          Send raw keystrokes with a set time delay of seconds

        .\Invoke-Transfer.ps1 -merge {B64FILE} -out {FILE}
          Merge Base64 file into original file in desired path

        .\Invoke-Transfer.ps1 -read {IMGFILE} -out {FILE}
          Read screenshot with Windows OCR and save output to file

 Warning: This tool only works on Windows 10 or greater
          OCR reading may not be entirely accurate
```

**Available Parameters**:
- `-split` → Split file into Base64 chunks for clipboard transfer
- `-merge` → Merge Base64 chunks back into original file
- `-read` → Use OCR to read text from screenshot
- `-plain` → Send raw keystrokes with time delays
- `-guaca` → Enable Apache Guacamole compatibility mode
- `-sec` → Set time delay between chunks in seconds

## 📸 Screenshots

<img width="1920" height="1008" alt="image" src="https://github.com/user-attachments/assets/fa353d97-7db7-4e0d-9a00-fffc35cf80ad" />


## 🗂️ Documentation

The detailed guide of use can be found at the following link:

https://darkbyte.net/transfiriendo-ficheros-en-entornos-restringidos-con-invoke-transfer


## 📄 License

This project is licensed under the GNU GPL-3.0 license - See the LICENSE file for more details.


## 👨‍💻 Credits and Contact

This tool has been created and designed from scratch by **Joel Gámez Molina** ([@JoelGMSec](https://twitter.com/JoelGMSec)) and **Héctor de Armas Padrón** ([@3v4si0n](https://twitter.com/3v4si0n)).

Other ways to contact me on my blog [darkbyte.net](https://darkbyte.net)


## ⚠️ Disclaimer

This software comes with no warranty, exclusively for educational purposes and authorized security audits.

The author is not responsible for any misuse or damage caused by this software.

# ☕ Support
Support our work by buying us a coffee:

[<img width=250 alt="buymeacoffe" src="https://cdn.buymeacoffee.com/buttons/v2/default-blue.png">](https://www.buymeacoffee.com/joelgmsec)
