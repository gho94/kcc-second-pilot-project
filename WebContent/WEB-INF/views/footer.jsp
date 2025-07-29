<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<fmt:setBundle basename="Main"/>
<footer class="footer">
    <div class="container">
        <!-- 저작권 섹션 -->
        <div class="copyright-section">
            <fmt:message key="COPYRIGHT"/>
        </div>
        
        <!-- 상세 정보 섹션 -->
        <div class="footer-content" id="footerContent">
            <div class="row align-items-center">
                <!-- 회사 정보 -->
                <div class="col-lg-5 col-md-6">
                    <div class="company-info">
                        <div class="logo"></div>
                        <div class="subtitle"><fmt:message key="TEAM_NAME"/></div>
                        <div class="address">
                            <fmt:message key="ADDRESS"/><br>
                            <fmt:message key="MEMBERS"/>
                        </div>
                    </div>
                </div>
                <!-- 구분선 -->
                <div class="col-lg-2 d-none d-lg-block">
                    <div class="vertical-divider"></div>
                </div>
                <!-- <fmt:message key="CONTACT"/> 정보 -->
                <div class="col-lg-5 col-md-6">
                    <div class="contact-info">
                        <h4><fmt:message key="CONTACT"/></h4>
                        <a href="mailto:<fmt:message key="EMAIL"/>" class="email"><fmt:message key="EMAIL"/> kolgu96@naver.com</a>
                        <div class="phone"><fmt:message key="PHONE"/></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="kimbap-icon"></div>
    </div>
</footer>
<script src="/resources/js/footer.js"></script>