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
	let optionsHtml = '<option value="">재료를 선택해주세요</option>'
	window.allIngredients.forEach((ing) => {
		if (!selectedIngredients.has(ing.id)) {
			optionsHtml += `<option value="${ing.id}" data-unit="${ing.unit || ""}">${ing.name}</option>`
		}
	})

	newRow.innerHTML = `
        <div class="table-cell ingredient-col">
            <select name="ingredientId" data-valid="재료를 선택해주세요." class="field-select ingredient-select" data-row-id="${newRow.id}">
                ${optionsHtml}
            </select>
        </div>
        
        <div class="table-cell quantity-col">
            <input type="number" data-valid="수량을 입력해주세요." name="quantity" class="field-input" min="0.1" step="0.1" placeholder="1" required />
        </div>
        
        <div class="table-cell unit-col">
            <input type="text" data-valid="단위를 입력해주세요." name="unit" class="field-input" placeholder="g" required />
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
		select.addEventListener("change", function() {
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

// 토스트 메시지 표시
function showToast(message, type = "success") {
	alert(message);
}
