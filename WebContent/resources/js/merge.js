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

let isValidating = false;
let selectedData = null;
function renderRoleList() {
	ListRenderer.createList('roleList', roleData, {
		itemClass: 'modal-item',
		template: (role) => {
			const isSelected = currentValueId.map(Number).includes(Number(role.id));
			return `
                <span>${role.name}</span>
                <span class="checkmark" data-selected="${isSelected}" data-value="${role.id}" style="display: ${isSelected ? 'flex' : 'none'};">✓</span>
            `;
		},
		onClick: (role, element) => {
			// 기존 선택 해제
			document.querySelectorAll('.modal-item').forEach(item => {
				item.classList.remove('selected');
				const checkmark = item.querySelector('.checkmark');
				if (checkmark) checkmark.style.display = 'none';
			});

			// 새로운 선택 (element가 이미 .modal-item div임)
			element.classList.add('selected');
			const checkmark = element.querySelector('.checkmark');
			if (checkmark) checkmark.style.display = 'flex';
		}
	});
}

function renderRoleFeatureList() {
	ListRenderer.createList('roleFeatureList', roleNameMap, {
		itemClass: 'modal-item',
		template: (role) => {
			const isSelected = currentValueId.includes(role.id);
			return `
                <span>${role.name}</span>
                <span class="checkmark" data-selected="${isSelected}" data-value="${role.id}" style="display: ${isSelected ? 'flex' : 'none'};">✓</span>
            `;
		},
		onClick: (role, element) => {
			const checkmark = element.querySelector('.checkmark');
			const isSelected = element.classList.contains('selected');

			if (isSelected) {
				// 선택 해제
				element.classList.remove('selected');
				if (checkmark) checkmark.style.display = 'none';
			} else {
				// 선택
				element.classList.add('selected');
				if (checkmark) checkmark.style.display = 'flex';
			}
		}
	});
}

function confirmRoleSelection() {
	getModalSelectedItems(roleData);
	ModalManager.handleConfirm('roleModal', {
		displayElementId: 'selectedRoleText',
		valueElementId: 'roleId',
		errorMessage: '권한을 선택해주세요.'
	});
}

function confirmRoleFeatureModalSelection() {
	getModalSelectedItems(roleNameMap);
	ModalManager.handleConfirm('roleFeatureModal', {
		displayElementId: 'selectedRoleFeatureText',
		valueElementId: 'featureCodes',
		errorMessage: '권한을 선택해주세요.'
	});
}

function getModalSelectedItems(allList) {
	const selectedIds = Array.from(document.querySelectorAll('.checkmark'))
		.filter(el => el.style.display === 'flex').map(el => el.getAttribute('data-value'));

	selectedData = allList.filter(data => selectedIds.includes(data.id));
}


function getPostposition(word) {
	const lastChar = word[word.length - 1];
	const hasFinalConsonant = (lastChar.charCodeAt(0) - 44032) % 28 !== 0;
	return hasFinalConsonant ? '이' : '가';
}

function togglePasswordField() {
	const checkbox = document.getElementById('changePassword');
	const passwordField = document.getElementById('passwordField');
	const changePasswordFlag = document.getElementById('changePasswordFlag');

	if (checkbox.checked) {
		passwordField.disabled = false;
		passwordField.focus();
		changePasswordFlag.value = 'true';
	} else {
		passwordField.disabled = true;
		passwordField.value = '';
		changePasswordFlag.value = 'false';
	}
}

function validateForm() {
	const validationElements = document.querySelectorAll('[data-valid]');

	for (let element of validationElements) {
		const message = element.getAttribute('data-valid');
		const validType = element.getAttribute('data-valid-type');
		const validCondition = element.getAttribute('data-valid-condition');
		const valueTrim = element.value.trim();
		// 조건부 검증 (비밀번호 변경 체크박스 등)
		if (validCondition) {
			if (validCondition === 'changePassword') {
				const changePasswordChecked = document.getElementById('changePassword').checked;
				if (!changePasswordChecked) {
					continue; // 비밀번호 변경하지 않으면 검증 건너뛰기
				}
			}
		}

		// 비활성화된 필드는 검증하지 않음
		if (element.disabled) {
			continue;
		}

		// 빈 값 검증
		if (!valueTrim || (
		        ['hidden', 'number'].includes(element.type) && 
		        valueTrim === '0' && 
		        element.dataset.validNozero === 'true'
		    )) {
			showValidationError(element, message);
			return false;
		}

		// 이메일 형식 검증
		if (validType === 'email') {
			const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
			if (!emailRegex.test(valueTrim)) {
				showValidationError(element, '올바른 이메일 형식을 입력해주세요');
				return false;
			}
		}
	}

	return true;
}

// 검증 오류 표시 함수
function showValidationError(element, message) {
	isValidating = true;
	element.style.borderColor = '#e74c3c';
	element.style.boxShadow = '0 0 0 3px rgba(231, 76, 60, 0.15)';

	// 해당 요소로 스크롤 및 포커스
	element.scrollIntoView({ behavior: 'smooth', block: 'center' });
	element.focus();
	alert(message);
	setTimeout(() => {
		element.focus();
		isValidating = false;
	}, 50);
}

function clearValidationError(element) {
	if (isValidating) {
		return;
	}
	element.style.borderColor = '';
	element.style.boxShadow = '';
}

function clearAllValidationErrors() {
	const validationElements = document.querySelectorAll('[data-valid]');
	validationElements.forEach(element => {
		clearValidationError(element);
	});
}

// 입력 시 실시간 검증 오류 제거
document.addEventListener('DOMContentLoaded', function() {
	const validationElements = document.querySelectorAll('[data-valid]');

	validationElements.forEach(element => {
		element.addEventListener('input', function() {
			clearValidationError(this);
		});

		element.addEventListener('focus', function() {
			clearValidationError(this);
		});
	});

	document.querySelectorAll('input[type="number"]').forEach(input => {
		input.addEventListener('input', () => {
			if (input.value.startsWith('0') && input.value.length > 1) {
				input.value = input.value.replace(/^0+/, '');
			}
		});
	});

	document.querySelectorAll('input[type="number"]').forEach(input => {
		input.addEventListener('input', () => {
			if (input.value.startsWith('0') && input.value.length > 1) {
				input.value = input.value.replace(/^0+/, '');
			}
		});
	});
});

// 폼 제출 시 검증
document.querySelector('form').addEventListener('submit', function(e) {
	e.preventDefault(); // 일단 제출 막기
	clearAllValidationErrors();

	if (validateForm()) {
		this.submit();
	}
});
// ========================================
// 모달 관리 함수들
// ========================================

const ModalManager = {
	// 모달 열기
	open(modalId, options = {}) {
		const overlay = document.getElementById(modalId);
		if (!overlay) {
			return;
		}

		overlay.style.display = "block";
		document.body.style.overflow = "hidden";

		// 🔥 모달 내부의 .modal 도 같이 보이도록 설정!
		const modal = overlay.querySelector(".modal");
		if (modal) {
			modal.style.display = "block";
		}

		if (options.onOpen) options.onOpen();

		const firstFocusable = overlay.querySelector(
			'button, input, select, textarea, [tabindex]:not([tabindex="-1"])'
		);
		if (firstFocusable) firstFocusable.focus();
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

	handleConfirm(modalId, options = {}) {
		// 필수 체크
		if (selectedData.length === 0 || !selectedData) {
			const errorMessage = options.errorMessage || '항목을 선택해주세요.';
			if (typeof MessageManager !== 'undefined') {
				MessageManager.showError(errorMessage);
			} else {
				alert(errorMessage);
			}
			return false;
		}

		// 1. 텍스트 업데이트 (displayElement가 있으면)
		const displayTexts = selectedData?.map(item => item.name).join(', ');
		if (options.displayElementId) {
			const displayElement = document.getElementById(options.displayElementId);
			if (displayElement) {
				displayElement.textContent = displayTexts;
			}
		}

		// 2. 숨겨진 input 값 업데이트 (valueElementId가 있으면)
		if (options.valueElementId) {

			const valueElement = document.getElementById(options.valueElementId);
			const selectedIds = selectedData?.map(item => item.id);
			const value = selectedIds.join(', ');
			window.currentValueId = selectedIds;
			if (valueElement) {
				valueElement.value = value;
			}
		}

		// 3. 커스텀 콜백 실행 (추가 처리가 필요한 경우)
		if (options.onConfirm) {
			options.onConfirm(selectedData);
		}

		// 4. 모달 닫기
		this.close(modalId);

		// 5. 성공 메시지
		if (options.showSuccessMessage !== false) { // 기본값 true
			const successMessage = options.successMessage ||
				`"${displayTexts || '항목'}"이(가) 선택되었습니다.`;

			if (typeof MessageManager !== 'undefined') {
				MessageManager.showSuccess(successMessage);
			}
		}

		return true;
	}
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
				if (element.querySelector('[data-selected="true"]')) element.classList.add('selected');
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

			container.appendChild(element);
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

// 전역 객체로 내보내기
window.AppUtils = {
	AppState,
	ModalManager,
	ListRenderer,
	MessageManager
}
