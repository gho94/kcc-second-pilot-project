// 전역 변수
let ingredientCounter = 0
const selectedIngredients = new Set() // 선택된 재료 ID를 추적

// 페이지 로드 시 초기화
document.addEventListener("DOMContentLoaded", () => {
  console.log("페이지 초기화 시작")

  // 재료 데이터 확인
  if (!window.allIngredients || window.allIngredients.length === 0) {
    console.error("재료 데이터가 없습니다!")
    return
  }

  console.log("사용 가능한 재료 수:", window.allIngredients.length)

  // 이벤트 리스너 등록
  setupEventListeners()

  // 폼 제출 이벤트 설정
  setupFormSubmission()
})

// 이벤트 리스너 설정
function setupEventListeners() {
  // 재료 추가 버튼
  const addIngredientBtn = document.getElementById("addIngredientBtn")
  if (addIngredientBtn) {
    addIngredientBtn.addEventListener("click", addIngredientRow)
    console.log("재료 추가 버튼 이벤트 등록됨")
  }

  // 취소 버튼
  const cancelBtn = document.getElementById("cancelBtn")
  if (cancelBtn) {
    cancelBtn.addEventListener("click", goBack)
  }
}

// 재료 행 추가
function addIngredientRow() {
  console.log("재료 행 추가")

  const menuSelect = document.getElementById("menuId")
  if (!menuSelect || !menuSelect.value) {
    showToast("먼저 메뉴를 선택해주세요.", "error")
    return
  }

  const container = document.getElementById("ingredientsTable")
  if (!container) {
    console.error("ingredientsTable 컨테이너를 찾을 수 없습니다")
    return
  }

  const newRow = document.createElement("div")
  newRow.className = "table-row ingredient-row"
  newRow.id = `ingredient-row-${++ingredientCounter}`

  // 사용 가능한 재료 옵션 생성 (이미 선택된 재료 제외)
  let optionsHtml = '<option value="">-- 재료를 선택해주세요 --</option>'
  window.allIngredients.forEach((ing) => {
    if (!selectedIngredients.has(ing.id)) {
      optionsHtml += `<option value="${ing.id}" data-unit="${ing.unit || ""}">${ing.name}</option>`
    }
  })

  newRow.innerHTML = `
        <div class="table-cell ingredient-col">
            <select name="ingredientId" class="field-select ingredient-select" data-row-id="${newRow.id}">
                ${optionsHtml}
            </select>
        </div>
        
        <div class="table-cell quantity-col">
            <input type="number" name="quantity" class="field-input" min="0.1" step="0.1" placeholder="1" required />
        </div>
        
        <div class="table-cell unit-col">
            <input type="text" name="unit" class="field-input" placeholder="g" required />
        </div>
        
        <div class="table-cell description-col">
            <input type="text" name="description" class="field-input" placeholder="예: 잘게 다져서" />
        </div>
        
        <div class="table-cell action-col">
            <button type="button" class="delete-btn" onclick="removeIngredientRow('${newRow.id}')">삭제</button>
        </div>
    `

  container.appendChild(newRow)

  // 재료 선택 시 이벤트 등록 (중복 방지 로직 포함)
  const select = newRow.querySelector(".ingredient-select")
  if (select) {
    select.addEventListener("change", function () {
      handleIngredientSelection(this)
    })
  }

  console.log("새 재료 행 추가됨:", newRow.id)
  newRow.scrollIntoView({ behavior: "smooth", block: "center" })
}

// 재료 선택 처리 함수 (새로 추가)
function handleIngredientSelection(selectElement) {
  const rowId = selectElement.dataset.rowId
  const previousValue = selectElement.dataset.previousValue
  const currentValue = selectElement.value

  // 이전에 선택된 재료가 있다면 선택 해제
  if (previousValue) {
    selectedIngredients.delete(previousValue)
  }

  // 새로 선택된 재료가 있다면 선택 목록에 추가
  if (currentValue) {
    if (selectedIngredients.has(currentValue)) {
      // 이미 선택된 재료인 경우 (이론적으로는 발생하지 않아야 함)
      showToast("이미 선택된 재료입니다.", "error")
      selectElement.value = ""
      return
    }
    selectedIngredients.add(currentValue)
    selectElement.dataset.previousValue = currentValue

    // 단위 자동 입력
    updateUnit(selectElement)
  } else {
    // 선택 해제된 경우
    delete selectElement.dataset.previousValue
  }

  // 모든 드롭다운 업데이트
  updateAllDropdowns()

  console.log("현재 선택된 재료들:", Array.from(selectedIngredients))
}

// 모든 드롭다운 업데이트 함수 (새로 추가)
function updateAllDropdowns() {
  const selects = document.querySelectorAll(".ingredient-select")

  selects.forEach((select) => {
    const currentValue = select.value
    const rowId = select.dataset.rowId

    // 옵션 재생성
    let optionsHtml = '<option value="">-- 재료를 선택해주세요 --</option>'

    window.allIngredients.forEach((ing) => {
      // 현재 선택된 값이거나 아직 선택되지 않은 재료만 표시
      if (ing.id === currentValue || !selectedIngredients.has(ing.id)) {
        const selected = ing.id === currentValue ? "selected" : ""
        optionsHtml += `<option value="${ing.id}" data-unit="${ing.unit || ""}" ${selected}>${ing.name}</option>`
      }
    })

    select.innerHTML = optionsHtml
  })
}

// 단위 자동 입력
function updateUnit(selectElement) {
  const selectedOption = selectElement.options[selectElement.selectedIndex]
  const row = selectElement.closest(".table-row")
  const unitInput = row.querySelector('input[name="unit"]')

  if (selectedOption.dataset.unit && unitInput) {
    unitInput.value = selectedOption.dataset.unit
    unitInput.style.transform = "scale(1.05)"
    setTimeout(() => {
      unitInput.style.transform = "scale(1)"
    }, 200)
  }
}

// 재료 행 제거
function removeIngredientRow(rowId) {
  const row = document.getElementById(rowId)
  if (row) {
    const select = row.querySelector(".ingredient-select")
    const selectedValue = select ? select.value : null

    // 선택된 재료가 있다면 선택 목록에서 제거
    if (selectedValue) {
      selectedIngredients.delete(selectedValue)
      console.log("재료 선택 해제됨:", selectedValue)
    }

    row.classList.add("removing")
    setTimeout(() => {
      row.remove()
      // 모든 드롭다운 업데이트
      updateAllDropdowns()
      showToast("재료가 제거되었습니다.")
    }, 300)
  }
}

// 폼 제출 설정에서 중복 검사 부분 제거 (이미 실시간으로 방지되므로)
function setupFormSubmission() {
  const form = document.querySelector(".recipe-form")
  if (form) {
    form.addEventListener("submit", (e) => {
      // 메뉴 선택 확인
      const menuSelect = document.getElementById("menuId")
      if (!menuSelect || !menuSelect.value) {
        e.preventDefault()
        showToast("메뉴를 선택해주세요.", "error")
        return false
      }

      // 재료 추가 확인
      const ingredientRows = document.querySelectorAll(".ingredient-row")
      if (ingredientRows.length === 0) {
        e.preventDefault()
        showToast("최소 하나의 재료는 추가해야 합니다.", "error")
        return false
      }

      // 각 재료 행 유효성 검사
      let hasError = false
      ingredientRows.forEach((row, index) => {
        const select = row.querySelector('select[name="ingredientId"]')
        const quantityInput = row.querySelector('input[name="quantity"]')
        const unitInput = row.querySelector('input[name="unit"]')

        if (!select.value) {
          showToast(`${index + 1}번째 재료를 선택해주세요.`, "error")
          select.focus()
          hasError = true
          return
        }

        if (!quantityInput.value || quantityInput.value <= 0) {
          showToast(`${index + 1}번째 재료의 수량을 입력해주세요.`, "error")
          quantityInput.focus()
          hasError = true
          return
        }

        if (!unitInput.value) {
          showToast(`${index + 1}번째 재료의 단위를 입력해주세요.`, "error")
          unitInput.focus()
          hasError = true
          return
        }
      })

      if (hasError) {
        e.preventDefault()
        return false
      }

      // 제출 확인
      if (!confirm("레시피를 등록하시겠습니까?")) {
        e.preventDefault()
        return false
      }

      // 로딩 상태 표시
      const submitBtn = form.querySelector(".submit-btn")
      if (submitBtn) {
        submitBtn.innerHTML = '<span class="btn-icon">⏳</span> 등록 중...'
        submitBtn.disabled = true
      }

      return true
    })
  }
}

// 토스트 메시지 표시
function showToast(message, type = "success") {
  const toast = document.getElementById("toast")
  if (toast) {
    toast.textContent = message
    toast.className = `toast ${type}`
    toast.classList.add("show")

    setTimeout(() => {
      toast.classList.remove("show")
    }, 3000)
  }
  console.log(`Toast: ${message} (${type})`)
}

// 뒤로 가기
function goBack() {
  if (confirm("등록을 취소하고 목록으로 돌아가시겠습니까?")) {
    window.location.href = "/recipe/list.do"
  }
}
