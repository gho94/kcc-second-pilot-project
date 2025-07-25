<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>COOKCOOK - 레시피 등록</title>
    <link rel="stylesheet" href="recipe-style.css">
</head>
<body>
    <!-- 상단 헤더 -->
    <header class="top-header">
        <div class="header-content">
            <div class="logo">
                <h1>COOKCOOK</h1>
            </div>
            <nav class="main-nav">
                <a href="#" class="nav-item">레시피 관리</a>
                <a href="#" class="nav-item">카테고리 관리</a>
                <a href="#" class="nav-item">권한 관리</a>
                <a href="#" class="nav-item">주문 관리</a>
                <a href="#" class="nav-item">메뉴 관리</a>
                <a href="#" class="nav-item">메뉴 카테고리 관리</a>
                <a href="#" class="nav-item active">작업자 관리</a>
            </nav>
            <div class="user-profile">
                <div class="profile-icon">👤</div>
            </div>
        </div>
    </header>

    <!-- 메인 컨테이너 -->
    <div class="main-container">
        <!-- 사이드바 -->
        <aside class="sidebar">
            <div class="sidebar-content">
                <h2 class="sidebar-title">레시피 등록</h2>
            </div>
        </aside>

        <!-- 메인 콘텐츠 -->
        <main class="main-content">
            <div class="content-header">
                <div class="page-actions">
                    <button type="button" class="btn btn-cancel" onclick="goBack()">목록으로</button>
                    <button type="submit" form="recipeForm" class="btn btn-primary">등록</button>
                </div>
            </div>

            <!-- 레시피 등록 폼 -->
            <div class="form-container">
                <form id="recipeForm" class="recipe-form">
                    
                    <!-- 메뉴 선택 섹션 -->
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">메뉴 선택 <span class="required">*</span></label>
                            <button type="button" class="select-input" onclick="openMenuModal()">
                                <span id="selectedMenuText" class="select-text">메뉴를 선택해주세요</span>
                                <span class="select-arrow">▼</span>
                            </button>
                        </div>
                    </div>
                    
                    <!-- 재료 선택 섹션 -->
                    <div class="form-row">
                        <div class="form-group full-width">
                            <label class="form-label">재료 선택 <span class="required">*</span></label>
                            <button type="button" class="select-input" onclick="openIngredientModal()">
                                <span class="select-text">재료를 선택해주세요</span>
                                <span class="select-arrow">▼</span>
                            </button>
                            
                            <!-- 선택된 재료들을 표시하는 영역 -->
                            <div class="selected-ingredients" id="selectedIngredientsContainer">
                                <div class="no-selection">선택된 재료가 없습니다.</div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- 설명란 섹션 -->
                    <div class="form-row">
                        <div class="form-group full-width">
                            <label class="form-label">레시피 설명 <span class="required">*</span></label>
                            <textarea 
                                class="form-textarea" 
                                name="description" 
                                placeholder="레시피 설명을 입력해주세요..."
                                id="recipeDescription"></textarea>
                        </div>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <!-- 메뉴 선택 모달 -->
    <div class="modal-overlay" id="menuModal">
        <div class="modal">
            <div class="modal-header">
                <h3 class="modal-title">메뉴 선택</h3>
                <button type="button" class="modal-close" onclick="closeMenuModal()">×</button>
            </div>
            
            <div class="modal-content" id="menuList">
                <!-- JavaScript로 동적으로 생성됨 -->
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeMenuModal()">취소</button>
                <button type="button" class="btn btn-primary" onclick="confirmMenuSelection()">확인</button>
            </div>
        </div>
    </div>

    <!-- 재료 선택 모달 -->
    <div class="modal-overlay" id="ingredientModal">
        <div class="modal">
            <div class="modal-header">
                <h3 class="modal-title">재료 선택</h3>
                <button type="button" class="modal-close" onclick="closeIngredientModal()">×</button>
            </div>
            
            <div class="modal-content" id="ingredientList">
                <!-- JavaScript로 동적으로 생성됨 -->
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeIngredientModal()">취소</button>
                <button type="button" class="btn btn-primary" onclick="confirmIngredientSelection()">확인</button>
            </div>
        </div>
    </div>

    <script src="recipe-script.js"></script>
</body>
</html>
