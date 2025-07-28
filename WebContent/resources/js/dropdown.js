class CustomDropdown {
	constructor(element) {
		this.dropdown = element;
		this.trigger = element.querySelector('.dropdown-trigger');
		this.list = element.querySelector('.dropdown-list');
		this.textElement = element.querySelector('.dropdown-text');
		this.hiddenInput = element.querySelector('input[type="hidden"]');
		this.items = element.querySelectorAll('li');
		this.selectedValue = null;
		this.isOpen = false;

		this.init();
	}

	init() {
		// 초기 선택된 값 설정
		const selectedItem = this.dropdown.querySelector('li.selected');
		if (selectedItem) {
			this.selectedValue = selectedItem.dataset.value;
			this.textElement.textContent = selectedItem.textContent.trim();
			this.trigger.classList.remove('placeholder');
			if (this.hiddenInput) {
				this.hiddenInput.value = this.selectedValue;
			}
		}

		// 이벤트 리스너 등록
		this.trigger.addEventListener('click', (e) => this.toggle(e));
		this.trigger.addEventListener('keydown', (e) => this.handleKeydown(e));

		this.items.forEach(item => {
			item.addEventListener('click', (e) => this.selectItem(e));
		});

		// 외부 클릭 시 닫기
		document.addEventListener('click', (e) => {
			if (!this.dropdown.contains(e.target)) {
				this.close();
			}
		});
	}

	toggle(e) {
		e.preventDefault();
		e.stopPropagation();

		if (this.isOpen) {
			this.close();
		} else {
			this.open();
		}
	}

	open() {
		this.trigger.classList.add('active');
		this.list.classList.add('show');
		this.isOpen = true;
	}

	close() {
		this.trigger.classList.remove('active');
		this.list.classList.remove('show');
		this.isOpen = false;
	}

	selectItem(e) {
		e.preventDefault();
		e.stopPropagation();

		const item = e.target;
		const value = item.dataset.value;
		const text = item.textContent.trim();

		// 이전 선택 해제
		this.items.forEach(i => i.classList.remove('selected'));

		// 새 선택 설정
		item.classList.add('selected');
		this.selectedValue = value;
		this.textElement.textContent = text;
		this.trigger.classList.remove('placeholder');

		// hidden input 값 업데이트
		if (this.hiddenInput) {
			this.hiddenInput.value = value;
		}

		this.close();

		// 커스텀 이벤트 발생
		this.dropdown.dispatchEvent(new CustomEvent('change', {
			detail: { value: value, text: text }
		}));
	}

	handleKeydown(e) {
		switch (e.key) {
			case 'Enter':
			case ' ':
				e.preventDefault();
				this.toggle(e);
				break;
			case 'Escape':
				this.close();
				break;
			case 'ArrowDown':
				e.preventDefault();
				if (!this.isOpen) {
					this.open();
				} else {
					this.focusNext();
				}
				break;
			case 'ArrowUp':
				e.preventDefault();
				if (this.isOpen) {
					this.focusPrevious();
				}
				break;
		}
	}

	focusNext() {
		// 키보드 네비게이션 구현 (선택사항)
	}

	focusPrevious() {
		// 키보드 네비게이션 구현 (선택사항)
	}

	getValue() {
		return this.selectedValue;
	}

	setValue(value) {
		const item = this.dropdown.querySelector(`li[data-value="${value}"]`);
		if (item) {
			this.selectItem({ target: item, preventDefault: () => { }, stopPropagation: () => { } });
		}
	}
}

// 드롭다운 초기화
document.addEventListener('DOMContentLoaded', function() {
	const dropdowns = document.querySelectorAll('.custom-dropdown');
	dropdowns.forEach(dropdown => {
		const customDropdown = new CustomDropdown(dropdown);
	});
});