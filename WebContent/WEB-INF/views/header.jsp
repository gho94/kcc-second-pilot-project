<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <header>
      <div class="header-container">
        <div class="logo-menu">
          <div class="burger" id="burgerBtn">
            <div></div>
            <div></div>
            <div></div>
          </div>
          <div class="logo">
            <div href="zootopia.do?command=main"></div>
          </div>
          <div class="nav">
          <c:forEach var="entry" items="${menuMap}">
            <div class="menu-wrap">
              <div class="menu-title">${entry.key}</div>
              <div class="submenu">
                <a href="${entry.value}">작업자 목록</a>
                <a href="#">작업자 등록</a>
              </div>
            </div>
            </c:forEach>
            <!-- 다른 메뉴들... -->
          </div>
        </div>

        <div class="profile_icon_con">
          <div id="profileIcon" class="profile-icon">
            <!-- 아이콘 (폰트어썸 사용 예시) -->
            <div class="user_icon"></div>

            <!-- 모달 -->
            <div id="profileModal" class="profile-modal">
              <div>
                <span class="profile-name"
                  >${staff.firstName}${staff.lastName}님</span
                >
                <button class="logout-btn" onclick="location.href='/logout.do'">
                  로그아웃
                </button>
              </div>
              <div class="row">
                <div class="col-12 mt-2 profile-desc">
                  이메일 : <%= session.getAttribute("userEmail") %>
                </div>
                <div class="col-12 mt-1 profile-desc">
                  권한명 : <%= session.getAttribute("userRole") %>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </header>
    <nav class="mobile-nav" id="mobileNav">
      <div style="overflow: visible; text-align: right; margin-bottom: 20px">
        <button
          id="closeMobileNav"
          style="border: 0; background-color: white; font-size: 18px"
        >
          ✕
        </button>
      </div>
      <c:forEach var="entry" items="${menuMap}">
	      <div class="menu-section">
	        <div class="menu-title">${entry.key}</div>
	        <div class="submenu">
	          <a href="${entry.value}">작업자 목록</a>
	          <a href="#">작업자 등록</a>
	        </div>
	      </div>
    </c:forEach>
    </nav>
 <script src="/resources/js/header.js"></script>