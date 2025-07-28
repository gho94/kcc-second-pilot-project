# COOOOK - 레스토랑 관리 시스템

## 📋 프로젝트 개요

COOOOK은 레스토랑의 전반적인 운영을 관리할 수 있는 웹 기반 관리 시스템입니다. 작업자 관리, 메뉴 관리, 주문 관리, 레시피 관리 등 레스토랑 운영에 필요한 모든 기능을 제공합니다.

## 🏗️ 프로젝트 아키텍처

### 기술 스택
- **Backend**: Java Servlet/JSP, JDBC
- **Database**: Oracle Database
- **Frontend**: HTML5, CSS3, JavaScript, Bootstrap
- **Build Tool**: Eclipse IDE
- **Server**: Apache Tomcat 9.0
- **Library**: Lombok, JSON, JSTL

### 아키텍처 패턴
- **MVC Pattern**: Model-View-Controller 패턴 적용
- **Front Controller Pattern**: DispatcherServlet을 통한 중앙 집중식 요청 처리
- **Command Pattern**: 각 요청을 별도의 Handler 클래스로 처리
- **DAO Pattern**: 데이터 접근 계층 분리
## 📁 프로젝트 구조

```
SecondProject/
├── src/
│   └── com/secondproject/cooook/
│       ├── common/           # 공통 유틸리티
│       ├── dao/             # 데이터 접근 객체
│       ├── db/              # 데이터베이스 연결 관리
│       ├── filter/          # 필터 (인코딩, 로그, 로케일)
│       ├── handler/         # 요청 처리 핸들러
│       │   ├── category/    # 카테고리 관련 핸들러
│       │   ├── menu/        # 메뉴 관련 핸들러
│       │   ├── order/       # 주문 관련 핸들러
│       │   ├── recipe/      # 레시피 관련 핸들러
│       │   ├── role/        # 권한 관련 핸들러
│       │   ├── session/     # 세션 관련 핸들러
│       │   └── staff/       # 작업자 관련 핸들러
│       ├── model/           # 엔티티 모델
│       ├── util/            # 유틸리티 클래스
│       └── web/             # 웹 관련 클래스
├── WebContent/
│   ├── resources/           # 정적 리소스
│   │   ├── css/            # 스타일시트
│   │   ├── js/             # 자바스크립트
│   │   └── img/            # 이미지
│   └── WEB-INF/
│       ├── views/          # JSP 뷰
│       ├── classes/        # 다국어 리소스
│       └── lib/            # 라이브러리
```

## 🚀 주요 기능

### 1. 대시보드
- 일일 통계 (주문 수, 레시피 수, 메뉴 수, 카테고리 수)
- 일주일 주문 총액 차트
- 최근 등록된 메뉴 목록

### 2. 작업자 관리
- 작업자 목록 조회
- 작업자 등록/수정/삭제
- 권한별 작업자 관리

### 3. 권한 관리
- 권한 목록 조회
- 권한 등록/수정/삭제
- 기능 코드별 권한 설정

### 4. 카테고리 관리
- 계층형 카테고리 구조
- 카테고리 추가/수정/삭제
- 트리 형태의 시각적 관리

### 5. 메뉴 관리
- 메뉴 목록 조회
- 메뉴 등록/수정/삭제
- 카테고리별 메뉴 분류

### 6. 주문 관리
- 주문 목록 조회
- 주문 등록/수정/삭제
- 주문 통계 및 분석

### 7. 레시피 관리
- 레시피 목록 조회
- 레시피 등록/수정/삭제
- 재료별 레시피 구성

## 🔧 설치 및 실행

### 필수 요구사항
- Java 8 이상
- Oracle Database
- Apache Tomcat 9.0
- Eclipse IDE (권장)

### 설치 단계

1. **데이터베이스 설정**
   ```sql
   -- Oracle Database 연결 설정
   -- JNDI 설정: java:comp/env/jdbc/Oracle
   ```

2. **프로젝트 빌드**
   ```bash
   # Eclipse에서 프로젝트 import
   # Dynamic Web Project로 설정
   ```

3. **서버 실행**
   ```bash
   # Tomcat 서버 시작
   # http://localhost:8080/SecondProject 접속
   ```

## 🌐 다국어 지원

- **한국어 (ko)**: 기본 언어
- **영어 (en)**: 국제화 지원
- **Locale Filter**: 자동 언어 감지 및 전환

## 🔒 보안 기능

- **세션 관리**: 로그인/로그아웃 처리
- **권한 기반 접근 제어**: 역할별 기능 접근 제한
- **비밀번호 암호화**: PasswordUtil을 통한 보안 강화

## 📊 데이터 모델

### 주요 엔티티
- **Staff**: 작업자 정보
- **Role**: 권한 정보
- **Category**: 카테고리 정보 (계층형)
- **Menu**: 메뉴 정보
- **Order**: 주문 정보
- **Recipe**: 레시피 정보
- **Ingredient**: 재료 정보

## 🎨 UI/UX 특징

- **반응형 디자인**: Bootstrap 기반 모바일 친화적 인터페이스
- **직관적인 네비게이션**: 사이드바 기반 메뉴 구조
- **실시간 데이터 시각화**: Chart.js를 활용한 통계 차트
- **사용자 친화적 폼**: 검증 및 피드백 기능

## 🔄 개발 패턴

### 1. Front Controller Pattern
```java
// DispatcherServlet이 모든 요청을 중앙에서 처리
public class DispatcherServlet extends HttpServlet {
    private Map<String, CommandHandler> commandHandlerMap;
    // 요청에 따른 적절한 Handler 호출
}
```

### 2. Command Pattern
```java
// 각 요청을 별도의 Handler로 처리
public interface CommandHandler {
    String process(HttpServletRequest request, HttpServletResponse response);
}
```

### 3. DAO Pattern
```java
// 데이터 접근 계층 분리
public class MenuDao {
    public List<Menu> getAllMenus() { ... }
    public void insertMenu(Menu menu) { ... }
}
```

## 📈 성능 최적화

- **Connection Pool**: Tomcat JDBC Pool 사용
- **필터 체인**: 인코딩, 로그, 로케일 필터 최적화
- **리소스 관리**: 자동 리소스 해제 (try-with-resources)

## 🛠️ 유지보수

### 로그 시스템
- **FileLogFilter**: 모든 요청에 대한 로그 기록
- **에러 처리**: RuntimeException 및 404 에러 페이지 처리

### 확장성
- **모듈화된 구조**: 새로운 기능 추가 용이
- **설정 파일 기반**: command.properties를 통한 URL 매핑

## 👥 개발팀

**팀 침착해**
- 엄윤호
- 김건호  
- 이은비

## 📞 연락처

- **주소**: 서울 종로구 창경궁로 254 동원빌딩, 403호
- **이메일**: contact@cooook.com
- **전화**: 010-0000-0000

---

© 2025 COOOOK System. All rights reserved. 