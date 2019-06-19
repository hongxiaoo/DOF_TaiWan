import requests
from bs4 import BeautifulSoup
import pprint
headers = {
'user-agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.80 Safari/537.36',
'referer':'https://zh.gta5-mods.com/vehicles'
}
target_url = 'https://zh.gta5-mods.com/vehicles/highest-rated/1'
req = requests.get(target_url,headers = headers)

soup = BeautifulSoup(req.text,'html.parser')

print(soup.find_all('a'))