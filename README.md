# smpic
Windows下面的SM.MS图床上传工具

---
看到有网友说mac下面有好多图床上传小工具，Windows下面却没有。然后就花了个把小时用AHK撸了这个小工具。  

### 使用方式
1. 选中图片（可多选）
2. 按快捷键（可配置），默认 Ctrl+Alt+S
3. 图片地址已经保存到剪切板了（可配置支持markdown）

JSON返回结果日志默认都记录在log.txt(可关闭)，以防想删除图片的时候，找不到地址  
具体配置可参考smpic.ini里面的说明

### 下载地址
[smpic.exe](https://github.com/kookob/smpic/blob/master/exe/smpic.exe?raw=true)

### 致谢
感谢@Showfom提供这么好的图床(https://sm.ms)  
感谢网上提供的AHK类库(CreateFormData.ahk和JSON.ahk)
