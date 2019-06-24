import requests

target_url = 'https://down.qq.com/dnf/dltools/DNF_SEASON4_V13.0.31.0_Pack_0_tgod_signed.exe'


headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36'}

req = requests.get(target_url,headers=headers)

print(req.status_code)