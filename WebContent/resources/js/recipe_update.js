// 전역 변수
let allIngredients = []
const existingIngredientIds = new Set()

// 페이지 로드 시 초기화
document.addEventListener("DOMContentLoaded", () => {
  initializePage()
})

// 페이지 초기화
function initializePage() {
  // 기존 재료 ID 수집
  collectExistingIngredientIds()

  // 폼 제출 이벤트 설정
  setupFormSubmission()

  console.log("페이지 초기화 완료")
  console.log("사용 가능한 재료:", allIngredients)
  console.log("기존 재료 IDs:", existingIngredientIds)

  // 설명 필드 확인
  const descriptions = document.querySelectorAll('input[name="description"]')
  descriptions.forEach((input, index) => {
    console.log(`기존 설명 ${index}:`, input.value)
  })
}

// 기존 재료 ID 수집
function collectExistingIngredientIds() {
  document.querySelectorAll('input[name="ingredientId"]').forEach((input) => {
    if (input.value) {
      existingIngredientIds.add(input.value)
    }
  })
}

// 재료 행 추가 함수
function addIngredientRow() {
  const tbody = document.getElementById("ingredientTableBody")
  const row = document.createElement("div")
  row.className = "table-row ingredient-row"

  // 사용 가능한 재료 필터링
  const availableIngredients = allIngredients.filter((ing) => !existingIngredientIds.has(ing.id))

  if (availableIngredients.length === 0) {
    showToast("추가할 수 있는 재료가 없습니다.", "error")
    return
  }

  // 재료 선택 드롭다운 생성
  const select = document.createElement("select")
  select.name = "ingredientId"
  select.className = "field-select"
  select.required = true

  const defaultOption = new Option("재료를 선택해주세요", "")
  select.appendChild(defaultOption)

  availableIngredients.forEach((ing) => {
    const option = new Option(ing.name, ing.id)
    option.dataset.unit = ing.unit
    select.appendChild(option)
  })

  // 단위 입력 필드
  const unitInput = document.createElement("input")
  unitInput.type = "text"
  unitInput.name = "unit"
  unitInput.className = "field-input unit-display"
  unitInput.placeholder = "단위"
  unitInput.required = true

  // 재료 선택 시 단위 자동 입력
  select.onchange = function () {
    const selected = this.options[this.selectedIndex]
    if (selected.value) {
      unitInput.value = selected.dataset.unit || ""
      existingIngredientIds.add(selected.value)

      // 다른 드롭다운에서 선택된 재료 제거
      updateAllDropdowns()

      // 부드러운 효과
      unitInput.style.transform = "scale(1.05)"
      setTimeout(() => {
        unitInput.style.transform = "scale(1)"
      }, 200)
    } else {
      unitInput.value = ""
    }
  }

  // 행 HTML 구성
  row.innerHTML = `
  		<div class="table-cell ingredient-col"></div>
        <div class="table-cell quantity-col"><input type="number" name="quantity" step="0.1" min="0.1" class="field-input" placeholder="1" required /></div>
        <div class="table-cell unit-col"></div>
        <div class="table-cell description-col"><input type="text" name="description" class="field-input" placeholder="예: 잘게 다져서" /></div>
        <div class="table-cell action-col">
            <button type="button" class="delete-btn" onclick="removeIngredientRow(this)">
                ✕
            </button>
        </div>
    `

  // 드롭다운과 단위 입력 필드 삽입
  row.children[0].appendChild(select)
  row.children[2].appendChild(unitInput)

  tbody.appendChild(row)

  // 새 행으로 스크롤
  row.scrollIntoView({ behavior: "smooth", block: "center" })
}

// 재료 행 제거 함수
function removeIngredientRow(button) {
  const row = button.closest("tr")
  const select = row.querySelector('select[name="ingredientId"]')

  if (select && select.value) {
    existingIngredientIds.delete(select.value)
    updateAllDropdowns()
  }

  row.style.opacity = "0"
  row.style.transform = "translateX(-100%)"
  setTimeout(() => {
    row.remove()
    showToast("재료 행이 제거되었습니다.")
  }, 300)
}

// 모든 드롭다운 업데이트
function updateAllDropdowns() {
  const selects = document.querySelectorAll('select[name="ingredientId"]')
  selects.forEach((select) => {
    const currentValue = select.value
    const availableIngredients = allIngredients.filter(
      (ing) => !existingIngredientIds.has(ing.id) || ing.id === currentValue,
    )

    // 옵션 재생성
    select.innerHTML = '<option value="">-- 재료를 선택해주세요 --</option>'
    availableIngredients.forEach((ing) => {
      const option = new Option(ing.name, ing.id)
      option.dataset.unit = ing.unit
      if (ing.id === currentValue) {
        option.selected = true
      }
      select.appendChild(option)
    })
  })
}

// 토스트 메시지 표시
function showToast(message, type = "success") {
 alert(message);
}

// 폼 제출 처리
function setupFormSubmission() {
  const form = document.getElementById("recipeForm")
  if (!form) return

  form.addEventListener("submit", (e) => {
    if (!confirm("레시피 수정을 저장하시겠습니까?")) {
      e.preventDefault()
      return false
    }

    // 로딩 상태 표시
    const submitBtn = form.querySelector(".submit-btn")

    form.classList.add("loading")
    submitBtn.innerHTML = '<span class="btn-icon">⏳</span> 저장 중...'
    submitBtn.disabled = true

    // 디버그 정보 출력
    console.log("=== 폼 제출 데이터 ===")
    const formData = new FormData(form)
    for (const pair of formData.entries()) {
      console.log(pair[0] + ": " + pair[1])
    }

    return true
  })
}

// 재료 데이터 설정 함수 (JSP에서 호출)
function setAllIngredients(ingredients) {
  allIngredients = ingredients
  console.log("재료 데이터 설정 완료:", allIngredients)
}
