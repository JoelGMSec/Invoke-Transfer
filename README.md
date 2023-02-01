<p align="center"><img width=600 alt="Invoke-Transfer" src="https://github.com/JoelGMSec/Invoke-Transfer/blob/main/Invoke-Transfer.png"></p>
**Invoke-Transfer** is a PowerShell Clipboard Data Transfer.
This tool helps you to send files in highly restricted environments such as Citrix, RDP, VNC, Guacamole.. using the clipboard function.
As long as you can send text through the clipboard, you can send files simulating a keyboard, in small Base64 encoded chunks.

# Requirements
- Powershell 5.1
- Windows 10 or greater

# Download
It is recommended to clone the complete repository or download the zip file.
You can do this by running the following command:
```
git clone https://github.com/JoelGMSec/Invoke-Transfer
```

# Usage
```
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

        .\Invoke-Transfer.ps1 -merge {B64FILE} -out {FILE}
          Merge Base64 file into original file in desired path

        .\Invoke-Transfer.ps1 -read {IMGFILE} -out {FILE}
          Read screenshot with Windows OCR and save output to file

 Warning: This tool only works on Windows 10 or greater
          OCR reading may not be entirely accurate

```

### The detailed guide of use can be found at the following link:
https://darkbyte.net/transfiriendo-ficheros-en-entornos-restringidos-con-invoke-transfer

# License
This project is licensed under the GNU 3.0 license - see the LICENSE file for more details.

# Credits and Acknowledgments
This tool has been created and designed from scratch by Joel Gámez Molina (@JoelGMSec) and Héctor de Armas Padrón (@3v4si0n).

# Contact
This software does not offer any kind of guarantee. Its use is exclusive for educational environments and / or security audits with the corresponding consent of the client. I am not responsible for its misuse or for any possible damage caused by it.
For more information, you can find us on Twitter as [@JoelGMSec](https://twitter.com/JoelGMSec), [@3v4si0n](https://twitter.com/3v4si0n) and on my blog [darkbyte.net](https://darkbyte.net).

# Support
You can support my work buying me a coffee:
[<img width=250 alt="buymeacoffe" src="https://cdn.buymeacoffee.com/buttons/v2/default-blue.png">](https://www.buymeacoffee.com/joelgmsec)
