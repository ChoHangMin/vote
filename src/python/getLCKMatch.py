from selenium import webdriver
from bs4 import BeautifulSoup
import re
import json

# Chrome WebDriver 실행 가능한 경로 설정 (chromedriver.exe 파일 경로)
webdriver_path = './chromedriver_win32/chromedriver.exe'

# 네이버 e스포츠 일정 페이지 URL
url = 'https://game.naver.com/esports/League_of_Legends/schedule/lck'

# Chrome WebDriver 옵션 설정
options = webdriver.ChromeOptions()
options.add_argument('--headless')  # 창 숨기기 (headless 모드로 실행)

# Chrome WebDriver 실행
driver = webdriver.Chrome(executable_path=webdriver_path, options=options)

# 웹 페이지 접속
driver.get(url)

# 페이지 로딩을 기다리기 위한 implicit wait 설정 (초 단위)
driver.implicitly_wait(10)

# 페이지 소스 가져오기
page_source = driver.page_source

# Chrome WebDriver 종료
driver.quit()

# BeautifulSoup를 사용하여 HTML 파싱
soup = BeautifulSoup(page_source, 'html.parser')

# script 태그에서 JSON 데이터 추출
json_data = None
scripts = soup.find_all('script')
for script in scripts:
    if 'id="__NEXT_DATA__"' in str(script):
        json_data = re.search(r'{.*}', str(script)).group(0)
        break

# 추출한 JSON 데이터를 파이썬 객체로 변환
if json_data:
    json_obj = json.loads(json_data)

    # JSON 데이터를 파일로 저장
    with open('./src/python/LCK_MATCH.json', 'w', encoding='utf-8') as file:
        json.dump(json_obj, file, ensure_ascii=False, indent=4)