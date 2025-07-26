<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.secondproject.cooook.model.Menu" %>
<%@ page import="com.secondproject.cooook.model.Ingredient" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");
    List<Ingredient> ingList = (List<Ingredient>) request.getAttribute("ingList");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>COOKCOOK - 새 레시피 등록</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: #f8f9fa;
            color: #333;
            line-height: 1.6;
        }

        /* 메인 컨테이너 */
        .main-container {
            padding: 30px;
            min-height: 100vh;
            max-width: 1200px;
            margin: 0 auto;
        }

        /* 페이지 헤더 */
        .page-header {
            background: white;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-title {
            font-size: 28px;
            font-weight: 600;
            color: #2c3e50;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .back-btn {
            background: #6c757d;
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            box-shadow: 0 2px 4px rgba(108, 117, 125, 0.3);
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }

        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(108, 117, 125, 0.4);
            background: #5a6268;
            text-decoration: none;
            color: white;
        }

        /* 폼 컨테이너 */
        .form-container {
            background: white;
            border-radius: 12px;
            padding: 40px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border: 1px solid #e9ecef;
        }

        .form-section {
            margin-bottom: 40px;
        }

        .section-title {
            font-size: 20px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #9dc3e6;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
            font-size: 15px;
        }

        .form-select {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            background-color: white;
            transition: all 0.3s ease;
        }

        .form-select:focus {
            outline: none;
            border-color: #9dc3e6;
            box-shadow: 0 0 0 3px rgba(157, 195, 230, 0.1);
        }

        .form-select:disabled {
            background-color: #f8f9fa;
            color: #6c757d;
            cursor: not-allowed;
        }

        /* 재료 입력 영역 */
        .ingredients-section {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 20px;
        }

        .ingredient-row {
            display: grid;
            grid-template-columns: 2.5fr 0.8fr 0.8fr 2.5fr auto;
            gap: 15px;
            align-items: end;
            margin-bottom: 20px;
            padding: 25px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        .ingredient-row:hover {
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .form-input {
            padding: 14px 16px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .form-input:focus {
            outline: none;
            border-color: #9dc3e6;
            box-shadow: 0 0 0 3px rgba(157, 195, 230, 0.1);
        }

        .form-input::placeholder {
            color: #6c757d;
        }

        .input-group-label {
            font-size: 13px;
            color: #6c757d;
            margin-bottom: 6px;
            font-weight: 500;
        }

        /* 버튼 스타일 */
        .btn {
            padding: 12px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: #9dc3e6;
            color: white;
            box-shadow: 0 2px 4px rgba(157, 195, 230, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(157, 195, 230, 0.4);
            background: #7ba7d1;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
            box-shadow: 0 2px 4px rgba(108, 117, 125, 0.3);
        }

        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(108, 117, 125, 0.4);
            background: #5a6268;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
            box-shadow: 0 2px 4px rgba(220, 53, 69, 0.3);
            padding: 8px 16px;
            font-size: 12px;
        }

        .btn-danger:hover {
            background: #c82333;
            transform: translateY(-1px);
        }

        .btn-success {
            background: #28a745;
            color: white;
            box-shadow: 0 2px 4px rgba(40, 167, 69, 0.3);
        }

        .btn-success:hover {
            background: #218838;
            transform: translateY(-2px);
        }

        .btn-success:disabled {
            background: #6c757d;
            cursor: not-allowed;
            opacity: 0.5;
            transform: none;
        }

        .btn-success:disabled:hover {
            transform: none;
        }

        /* 액션 버튼 영역 */
        .action-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid #e9ecef;
        }

        .add-ingredient-container {
            text-align: center;
            margin: 25px 0;
        }

        /* 알림 메시지 */
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-weight: 500;
            font-size: 14px;
        }

        .alert-info {
            background-color: #d1ecf1;
            border: 1px solid #bee5eb;
            color: #0c5460;
        }

        /* 반응형 */
        @media (max-width: 768px) {
            .main-container {
                padding: 20px 15px;
                max-width: 100%;
            }

            .page-header {
                flex-direction: column;
                gap: 15px;
                align-items: stretch;
                text-align: center;
            }

            .form-container {
                padding: 25px 20px;
            }

            .ingredient-row {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .action-buttons {
                flex-direction: column;
                gap: 15px;
            }
        }

        @media (max-width: 480px) {
            .main-container {
                padding: 15px 10px;
            }

            .page-title {
                font-size: 24px;
            }

            .form-container {
                padding: 20px 15px;
            }

            .section-title {
                font-size: 18px;
            }
        }

        /* 로딩 상태 */
        .loading {
            opacity: 0.6;
            pointer-events: none;
        }
    </style>
</head>
<body>
    <!-- 메인 컨테이너 -->
    <div class="main-container">
        <!-- 페이지 헤더 -->
        <div class="page-header">
            <h1 class="page-title">
                ➕ 새 레시피 등록
            </h1>
            <a href="list.do" class="back-btn">목록으로</a>
        </div>

        <div class="form-container">
            <form action="insert.do" method="post" id="recipeForm">
                <!-- 메뉴 선택 섹션 -->
                <div class="form-section">
                    <h3 class="section-title">메뉴 선택</h3>
                    <div class="form-group">
                        <label for="menuId" class="form-label">메뉴를 선택해주세요</label>
                        <select name="menuId" id="menuId" class="form-select" required>
                            <option value="">-- 레시피 미등록 메뉴 선택 --</option>
                            <c:forEach var="m" items="${menuList}">
                                <option value="${m.menuId}">${m.menuName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <!-- 재료 입력 섹션 -->
                <div class="form-section">
                    <h3 class="section-title">재료 정보</h3>
                    <div class="alert alert-info">
                        💡 먼저 메뉴를 선택한 후, 재료를 선택하고 수량과 설명을 입력해주세요.
                    </div>
                    
                    <div class="ingredients-section">
                        <div id="ingredientsContainer">
                            <div class="ingredient-row">
                                <div>
                                    <div class="input-group-label">재료 선택</div>
                                    <select name="ingredientId" class="form-select" required disabled>
                                        <option value="">-- 먼저 메뉴를 선택해주세요 --</option>
                                        <c:forEach var="i" items="${ingList}">
                                            <option value="${i.ingredientId}">${i.ingredientName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <div class="input-group-label">수량</div>
                                    <input type="text" 
                                           name="quantity" 
                                           class="form-input" 
                                           inputmode="decimal" 
                                           placeholder="예: 50" 
                                           required 
                                           oninput="this.value=this.value.replace(/[^0-9.]/g,'');">
                                </div>
                                <div>
                                    <div class="input-group-label">단위</div>
                                    <input type="text" 
                                           name="unit" 
                                           class="form-input" 
                                           placeholder="예: g, 개" 
                                           required>
                                </div>
                                <div>
                                    <div class="input-group-label">설명 (선택사항)</div>
                                    <input type="text" 
                                           name="description" 
                                           class="form-input" 
                                           placeholder="예: 잘게 다져서">
                                </div>
                                <div>
                                    <button type="button" class="btn btn-danger removeRow">삭제</button>
                                </div>
                            </div>
                        </div>

                        <div class="add-ingredient-container">
                            <button type="button" id="addIngredient" class="btn btn-success" disabled style="opacity: 0.5;">
                                ➕ 재료 추가
                            </button>
                        </div>
                    </div>
                </div>

                <!-- 액션 버튼 -->
                <div class="action-buttons">
                    <button type="submit" class="btn btn-primary">
                        ✅ 레시피 등록
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="location.href='list.do'">
                        ❌ 취소
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const menuSelect = document.getElementById('menuId');
            const container = document.getElementById('ingredientsContainer');
            const addBtn = document.getElementById('addIngredient');
            const form = document.getElementById('recipeForm');

            // 메뉴 선택 시 재료 드롭다운 활성화
            menuSelect.addEventListener('change', function() {
                const ingredientSelects = container.querySelectorAll('select[name="ingredientId"]');
                const addBtn = document.getElementById('addIngredient');
                
                if (this.value) {
                    // 메뉴가 선택되면 재료 선택 활성화
                    ingredientSelects.forEach(select => {
                        select.disabled = false;
                        select.querySelector('option[value=""]').textContent = '-- 재료 선택 --';
                    });
                    addBtn.disabled = false;
                    addBtn.style.opacity = '1';
                } else {
                    // 메뉴가 선택 해제되면 재료 선택 비활성화
                    ingredientSelects.forEach(select => {
                        select.disabled = true;
                        select.value = '';
                        select.querySelector('option[value=""]').textContent = '-- 먼저 메뉴를 선택해주세요 --';
                    });
                    addBtn.disabled = true;
                    addBtn.style.opacity = '0.5';
                    
                    // 모든 입력 필드 초기화
                    container.querySelectorAll('input').forEach(input => input.value = '');
                }
            });

            function updateIngredientOptions() {
                const selects = container.querySelectorAll('select[name="ingredientId"]');
                const chosen = Array.from(selects)
                                     .map(s => s.value)
                                     .filter(v => v);
                selects.forEach(select => {
                    Array.from(select.options).forEach(opt => {
                        opt.disabled = opt.value && chosen.includes(opt.value) && select.value !== opt.value;
                    });
                });
            }

            function validateForm() {
                const menuSelect = document.getElementById('menuId');
                if (!menuSelect.value) {
                    alert('메뉴를 선택해주세요.');
                    menuSelect.focus();
                    return false;
                }

                const selects = container.querySelectorAll('select[name="ingredientId"]');
                const quantities = container.querySelectorAll('input[name="quantity"]');
                const units = container.querySelectorAll('input[name="unit"]');
                
                let hasValidIngredient = false;
                for (let i = 0; i < selects.length; i++) {
                    if (selects[i].value && quantities[i].value.trim() && units[i].value.trim()) {
                        hasValidIngredient = true;
                        break;
                    }
                }

                if (!hasValidIngredient) {
                    alert('최소 하나의 재료, 수량, 단위를 모두 입력해주세요.');
                    return false;
                }

                // 로딩 상태 표시
                form.classList.add('loading');
                return true;
            }

            addBtn.addEventListener('click', function() {
                if (!menuSelect.value) {
                    alert('먼저 메뉴를 선택해주세요.');
                    return;
                }

                const lastRow = container.querySelector('.ingredient-row:last-child');
                const lastSelect = lastRow.querySelector('select[name="ingredientId"]');
                const lastQuantity = lastRow.querySelector('input[name="quantity"]');
                const lastUnit = lastRow.querySelector('input[name="unit"]');
                
                if (!lastSelect.value || !lastQuantity.value.trim() || !lastUnit.value.trim()) {
                    alert('현재 재료의 정보를 모두 입력한 후 추가해주세요.');
                    return;
                }

                const original = container.querySelector('.ingredient-row');
                const clone = original.cloneNode(true);
                clone.querySelectorAll('select, input').forEach(el => el.value = '');
                container.appendChild(clone);
                updateIngredientOptions();

                // 새로 추가된 행으로 스크롤
                clone.scrollIntoView({ behavior: 'smooth', block: 'center' });
            });

            container.addEventListener('click', function(e) {
                if (e.target.classList.contains('removeRow')) {
                    const rows = container.querySelectorAll('.ingredient-row');
                    if (rows.length > 1) {
                        e.target.closest('.ingredient-row').remove();
                        updateIngredientOptions();
                    } else {
                        alert('최소 하나의 재료 입력란은 필요합니다.');
                    }
                }
            });

            container.addEventListener('change', function(e) {
                if (e.target.matches('select[name="ingredientId"]')) {
                    updateIngredientOptions();
                }
            });

            form.addEventListener('submit', function(e) {
                if (!validateForm()) {
                    e.preventDefault();
                }
            });

            updateIngredientOptions();
        });
    </script>
</body>
</html>
