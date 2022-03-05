# smpic
Windows下面的SM.MS图床上传工具

---
看到有网友说mac下面有好多图床上传小工具，Windows下面却没有。然后就花了个把小时用AHK撸了这个小工具。  

### 使用方式
1. 选中图片（可多选）
2. 按快捷键（可配置），默认 Ctrl+Alt+S
3. 图片地址已经保存到剪切板了（可配置支持markdown）

因为SM.MS最新API更新了上传方式，只允许登录用户上传图片，所以需要使用该工具的朋友需要 [登录后台](https://sm.ms/home/apitoken) 生成自己的Secret Token，在配置文件里面替换为自己的。  
**具体配置可参考smpic.ini里面的说明**

### 下载地址
[smpic.exe](https://github.com/kookob/smpic/blob/master/exe/smpic.exe?raw=true)

### 致谢
感谢 [@Showfom](https://github.com/Showfom) 提供的图床(https://sm.ms)  
感谢网上提供的AHK类库(CreateFormData.ahk和JSON.ahk)
