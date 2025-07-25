// ========================================
// 공통 유틸리티 함수들
// ========================================

// 전역 변수
const AppState = {
  currentPage: 1,
  selectedItems: [],
  tempSelectedItems: [],
  expandedCategories: new Set(),
}

// ========================================
// 데이터 관리 함수들
// ========================================

// 샘플 데이터
const SampleData = {
  menus: [
    { id: 1, name: "김치찌개" },
    { id: 2, name: "된장찌개" },
    { id: 3, name: "불고기" },
    { id: 4, name: "비빔밥" },
    { id: 5, name: "냉면" },
    { id: 6, name: "갈비탕" },
    { id: 7, name: "삼겹살" },
    { id: 8, name: "치킨" },
    { id: 9, name: "피자" },
    { id: 10, name: "파스타" },
  ],

  ingredients: [
    { id: 1, name: "김치" },
    { id: 2, name: "돼지고기" },
    { id: 3, name: "두부" },
    { id: 4, name: "대파" },
    { id: 5, name: "양파" },
    { id: 6, name: "마늘" },
    { id: 7, name: "고춧가루" },
    { id: 8, name: "간장" },
    { id: 9, name: "참기름" },
    { id: 10, name: "소금" },
    { id: 11, name: "후추" },
    { id: 12, name: "설탕" },
    { id: 13, name: "된장" },
    { id: 14, name: "고추장" },
    { id: 15, name: "식용유" },
    { id: 16, name: "생강" },
    { id: 17, name: "당근" },
    { id: 18, name: "감자" },
  ],

  categories: [
    {
      id: 1,
      name: "전자제품",
      parentId: null,
      children: [
        {
          id: 2,
          name: "컴퓨터",
          parentId: 1,
          children: [
            {
              id: 3,
              name: "노트북",
              parentId: 2,
              children: [
                { id: 4, name: "게이밍 노트북", parentId: 3, children: [] },
                { id: 5, name: "비즈니스 노트북", parentId: 3, children: [] },
              ],
            },
            {
              id: 6,
              name: "데스크톱",
              parentId: 2,
              children: [
                { id: 7, name: "게이밍 PC", parentId: 6, children: [] },
                { id: 8, name: "사무용 PC", parentId: 6, children: [] },
              ],
            },
          ],
        },
        {
          id: 9,
          name: "스마트폰",
          parentId: 1,
          children: [
            { id: 10, name: "안드로이드", parentId: 9, children: [] },
            { id: 11, name: "아이폰", parentId: 9, children: [] },
          ],
        },
      ],
    },
    {
      id: 12,
      name: "의류",
      parentId: null,
      children: [
        {
          id: 13,
          name: "남성의류",
          parentId: 12,
          children: [
            { id: 14, name: "셔츠", parentId: 13, children: [] },
            { id: 15, name: "바지", parentId: 13, children: [] },
          ],
        },
        {
          id: 16,
          name: "여성의류",
          parentId: 12,
          children: [
            { id: 17, name: "원피스", parentId: 16, children: [] },
            { id: 18, name: "블라우스", parentId: 16, children: [] },
          ],
        },
      ],
    },
  ],

  employees: window.staffData || [],
}

// ========================================
// 모달 관리 함수들
// ========================================

const ModalManager = {
  // 모달 열기
  open(modalId, options = {}) {
    const modal = document.getElementById(modalId)
    if (!modal) return

    modal.style.display = "block"
    document.body.style.overflow = "hidden"

    // 콜백 실행
    if (options.onOpen) options.onOpen()

    // 첫 번째 포커스 가능한 요소에 포커스
    const firstFocusable = modal.querySelector('button, input, select, textarea, [tabindex]:not([tabindex="-1"])')
    if (firstFocusable) firstFocusable.focus()
  },

  // 모달 닫기
  close(modalId, options = {}) {
    const modal = document.getElementById(modalId)
    if (!modal) return

    modal.style.display = "none"
    document.body.style.overflow = "auto"

    // 콜백 실행
    if (options.onClose) options.onClose()
  },

  // 모든 모달 닫기
  closeAll() {
    document.querySelectorAll(".modal-overlay").forEach((modal) => {
      modal.style.display = "none"
    })
    document.body.style.overflow = "auto"
  },

  // 모달 외부 클릭 처리
  handleOutsideClick(event) {
    if (event.target.classList.contains("modal-overlay")) {
      this.close(event.target.id)
    }
  },
}

// ========================================
// 리스트 렌더링 함수들
// ========================================

const ListRenderer = {
  // 동적 리스트 생성
  createList(containerId, items, options = {}) {
    const container = document.getElementById(containerId)
    if (!container) return

    container.innerHTML = ""

    items.forEach((item) => {
      const element = document.createElement("div")
      element.className = options.itemClass || "list-item"
      element.setAttribute("tabindex", "0")

      if (options.template) {
        element.innerHTML = options.template(item)
      } else {
        element.textContent = item.name || item.toString()
      }

      // 클릭 이벤트
      if (options.onClick) {
        element.onclick = () => options.onClick(item, element)
      }

      // 키보드 이벤트
      element.onkeydown = (e) => {
        if (e.key === "Enter" || e.key === " ") {
          e.preventDefault()
          if (options.onClick) options.onClick(item, element)
        }
      }

      container.appendChild(element)
    })
  },

  // 선택 상태 업데이트
  updateSelection(containerId, selectedItems, itemIdKey = "id") {
    const container = document.getElementById(containerId)
    if (!container) return

    container.querySelectorAll(".list-item").forEach((element, index) => {
      const isSelected = selectedItems.some((item) => item[itemIdKey] === index + 1)
      element.classList.toggle("selected", isSelected)

      const checkmark = element.querySelector(".checkmark")
      if (checkmark) {
        checkmark.style.display = isSelected ? "flex" : "none"
      }
    })
  },
}

// ========================================
// 폼 검증 함수들
// ========================================

const FormValidator = {
  // 필수 필드 검증
  validateRequired(fieldId, message) {
    const field = document.getElementById(fieldId)
    if (!field) return false

    const value = field.value.trim()
    if (!value) {
      MessageManager.showError(message)
      field.focus()
      return false
    }
    return true
  },

  // 최소 길이 검증
  validateMinLength(fieldId, minLength, message) {
    const field = document.getElementById(fieldId)
    if (!field) return false

    const value = field.value.trim()
    if (value.length < minLength) {
      MessageManager.showError(message)
      field.focus()
      return false
    }
    return true
  },

  // 이메일 검증
  validateEmail(fieldId, message) {
    const field = document.getElementById(fieldId)
    if (!field) return false

    const value = field.value.trim()
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(value)) {
      MessageManager.showError(message)
      field.focus()
      return false
    }
    return true
  },

  // 배열 검증
  validateArray(array, message) {
    if (!Array.isArray(array) || array.length === 0) {
      MessageManager.showError(message)
      return false
    }
    return true
  },
}

// ========================================
// 메시지 관리 함수들
// ========================================

const MessageManager = {
  // 성공 메시지
  showSuccess(message, duration = 3000) {
    this.show(message, "success", duration)
  },

  // 에러 메시지
  showError(message, duration = 5000) {
    this.show(message, "error", duration)
  },

  // 정보 메시지
  showInfo(message, duration = 3000) {
    this.show(message, "info", duration)
  },

  // 메시지 표시
  show(message, type = "success", duration = 3000) {
    // 기존 메시지 제거
    const existingMessage = document.querySelector(".toast-message")
    if (existingMessage) existingMessage.remove()

    // 새 메시지 생성
    const messageDiv = document.createElement("div")
    messageDiv.className = `toast-message toast-${type}`

    const colors = {
      success: { bg: "#28a745", shadow: "40, 167, 69" },
      error: { bg: "#dc3545", shadow: "220, 53, 69" },
      info: { bg: "#17a2b8", shadow: "23, 162, 184" },
    }

    const color = colors[type] || colors.success

    messageDiv.style.cssText = `
            position: fixed;
            top: 80px;
            right: 20px;
            background: linear-gradient(135deg, ${color.bg}, ${color.bg}dd);
            color: white;
            padding: 12px 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(${color.shadow}, 0.3);
            z-index: 2001;
            font-weight: 500;
            font-size: 14px;
            animation: slideInRight 0.3s ease;
            max-width: 300px;
            word-wrap: break-word;
        `
    messageDiv.textContent = message

    // 애니메이션 스타일 추가
    if (!document.getElementById("toastAnimationStyle")) {
      const style = document.createElement("style")
      style.id = "toastAnimationStyle"
      style.textContent = `
                @keyframes slideInRight {
                    from { opacity: 0; transform: translateX(100%); }
                    to { opacity: 1; transform: translateX(0); }
                }
            `
      document.head.appendChild(style)
    }

    document.body.appendChild(messageDiv)

    // 자동 제거
    setTimeout(() => {
      if (messageDiv && messageDiv.parentNode) {
        messageDiv.style.animation = "slideInRight 0.3s ease reverse"
        setTimeout(() => {
          if (messageDiv.parentNode) messageDiv.remove()
        }, 300)
      }
    }, duration)
  },
}

// ========================================
// 유틸리티 함수들
// ========================================

const Utils = {
  // 디바운스
  debounce(func, wait) {
    let timeout
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout)
        func(...args)
      }
      clearTimeout(timeout)
      timeout = setTimeout(later, wait)
    }
  },

  // 깊은 복사
  deepClone(obj) {
    return JSON.parse(JSON.stringify(obj))
  },

  // 배열에서 객체 찾기
  findById(array, id, key = "id") {
    return array.find((item) => item[key] === id)
  },

  // 배열에서 객체 제거
  removeById(array, id, key = "id") {
    return array.filter((item) => item[key] !== id)
  },

  // 카테고리 경로 생성
  getCategoryPath(categories, targetId) {
    const path = []

    function findPath(items, target, currentPath) {
      for (const item of items) {
        const newPath = [...currentPath, item.name]

        if (item.id === target) {
          path.push(...newPath)
          return true
        }

        if (item.children && item.children.length > 0) {
          if (findPath(item.children, target, newPath)) {
            return true
          }
        }
      }
      return false
    }

    findPath(categories, targetId, [])
    return path.join(" > ")
  },

  // 텍스트 영역 자동 크기 조절
  autoResizeTextarea(textarea) {
    textarea.style.height = "auto"
    textarea.style.height = Math.max(120, textarea.scrollHeight) + "px"
  },

  // 로딩 상태 토글
  toggleLoading(buttonElement, isLoading, loadingText = "처리 중...") {
    if (isLoading) {
      buttonElement.dataset.originalText = buttonElement.textContent
      buttonElement.textContent = loadingText
      buttonElement.disabled = true
    } else {
      buttonElement.textContent = buttonElement.dataset.originalText || "확인"
      buttonElement.disabled = false
    }
  },

  // 확인 대화상자
  confirm(message, onConfirm, onCancel) {
    if (window.confirm(message)) {
      if (onConfirm) onConfirm()
    } else {
      if (onCancel) onCancel()
    }
  },
}

// ========================================
// 이벤트 관리자
// ========================================

const EventManager = {
  // 전역 이벤트 리스너 설정
  setupGlobalListeners() {
    // ESC 키로 모달 닫기
    document.addEventListener("keydown", (event) => {
      if (event.key === "Escape") {
        ModalManager.closeAll()
      }
    })

    // 모달 외부 클릭으로 닫기
    window.addEventListener("click", (event) => {
      ModalManager.handleOutsideClick(event)
    })

    // 텍스트 영역 자동 크기 조절
    document.addEventListener("input", (event) => {
      if (event.target.tagName === "TEXTAREA") {
        Utils.autoResizeTextarea(event.target)
      }
    })
  },

  // 폼 제출 이벤트 설정
  setupFormSubmit(formId, validator, submitter) {
    const form = document.getElementById(formId)
    if (!form) return

    form.addEventListener("submit", (e) => {
      e.preventDefault()

      if (validator && !validator()) {
        return false
      }

      if (submitter) {
        submitter()
      }

      return false
    })
  },

  // 검색 이벤트 설정
  setupSearch(inputId, searchFunction) {
    const input = document.getElementById(inputId)
    if (!input) return

    // 실시간 검색 (디바운스 적용)
    const debouncedSearch = Utils.debounce(searchFunction, 300)
    input.addEventListener("input", debouncedSearch)

    // 엔터 키 검색
    input.addEventListener("keypress", (e) => {
      if (e.key === "Enter") {
        searchFunction()
      }
    })
  },
}

// ========================================
// 초기화
// ========================================

// DOM 로드 시 전역 이벤트 리스너 설정
document.addEventListener("DOMContentLoaded", () => {
  EventManager.setupGlobalListeners()
})

// 전역 객체로 내보내기
window.AppUtils = {
  AppState,
  SampleData,
  ModalManager,
  ListRenderer,
  FormValidator,
  MessageManager,
  Utils,
  EventManager,
}
