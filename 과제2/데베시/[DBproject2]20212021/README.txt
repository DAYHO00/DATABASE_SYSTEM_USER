#20212021 원대호

부동산 관리 시스템

이 project는 MySQL database와 C++을 사용해 부동산 data를 관리하는 부동산 관리 system이다. 이 system은 판매자, 구매자, 중개인, 부동산 등 다양한 엔터티에 대한 작업을 지원한다.

프로젝트 구조
20212021.cpp: database 연결, 쿼리 실행 및 사용자 input 처리를 위한 C++ 소스 파일이다.
CRUD.txt: 데이터베이스 shema를 설정하고 초기 data를 삽입하는 SQL 스크립트 파일이다.

데이터베이스 및 테이블 생성:
CRUD.txt file에 있는 SQL 문을 실행해 데이터베이스와 table을 생성하고 초기 data를 삽입한다.

데이터베이스 연결 구성:
MySQL 서버가 실행 중이고 접근 가능한지 확인한다.

C++ 설정
MySQL C++ connector 설치:
MySQL 공식 웹사이트에서 MySQL C++ 커넥터를 download해 설치한다.

C++ 코드 컴파일:
선호하는 C++ complier를 사용해 20212021.cpp 파일을 complie한다. MySQL 클라이언트 라이브러리를 링크해야한다.

사용 방법
프로그램 실행:
컴파일된 바이너리를 실행한다

메인 메뉴:
프로그램이 다양한 쿼리 유형을 가진 menu를 표시한다. 특정 쿼리를 실행하려면 적절한 option을 선택한다.

쿼리 유형
유형 1: 특정 지역의 부동산 쿼리.
유형 2: 특정 school district의 부동산 쿼리.
유형 3: 중개인의 판매 성과 쿼리.
유형 4: 평균 판매 관련 쿼리.
유형 5: 부동산 사진 및 세부 사항 관련 쿼리.
유형 6: 새로운 판매 기록.
유형 7: 새로운 중개인 추가.

program은 각 쿼리 유형에 대해 다양한 하위 유형을 지원하여 보다 구체적인 쿼리를 실행할 수 있다.
CRUD.txt 파일이 실행 파일과 directory에 있는지 확인하거나 executeCrudFile 함수에서 올바른 route를 제공한다.

문제 해결
프로그램이 database에 연결하지 못하는 경우, 연결 매개변수를 확인하고 MySQL server가 실행 중인지 확인한다.
SQL 문 실행 중 error가 발생하면 CRUD.txt file의 구문을 확인하고 table이 올바르게 생성되었는지 확인한다.