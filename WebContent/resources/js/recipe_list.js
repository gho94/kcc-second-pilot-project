// 레시피 토글 함수
function toggleRecipes(menuId) {
  const recipesDiv = document.getElementById("recipes-" + menuId)
  const toggleIcon = document.getElementById("icon-" + menuId)

  if (recipesDiv.style.display === "none" || recipesDiv.style.display === "") {
    recipesDiv.style.display = "block"
    toggleIcon.textContent = "▼"
    toggleIcon.classList.add("expanded")
  } else {
    recipesDiv.style.display = "none"
    toggleIcon.textContent = "▶"
    toggleIcon.classList.remove("expanded")
  }
}

// 레시피 수정 함수
function updateRecipe(menuId) {
  window.location.href = "update.do?menuId=" + menuId
}

// 레시피 삭제 함수
function deleteRecipe(menuId) {
  if (confirm("이 메뉴의 레시피를 삭제하시겠습니까?")) {
    window.location.href = "delete.do?menuId=" + menuId
  }
}

// 검색 취소 함수
function cancelSearch() {
  window.location.href = window.location.pathname
}

// 페이지 로드 시 초기화
document.addEventListener("DOMContentLoaded", () => {
  // 검색어가 있으면 하이라이트
  const searchInput = document.querySelector(".search-input")
  if (searchInput && searchInput.value) {
    searchInput.focus()
  }

  // 테이블 행 호버 효과
  const tableRows = document.querySelectorAll(".recipe-table tbody tr")
  tableRows.forEach((row) => {
    row.addEventListener("mouseenter", function () {
      this.style.backgroundColor = "#f1f3f4"
    })

    row.addEventListener("mouseleave", function () {
      if (this.parentNode.children.length % 2 === 0) {
        if (Array.from(this.parentNode.children).indexOf(this) % 2 === 1) {
          this.style.backgroundColor = "white"
        } else {
          this.style.backgroundColor = ""
        }
      } else {
        if (Array.from(this.parentNode.children).indexOf(this) % 2 === 0) {
          this.style.backgroundColor = "white"
        } else {
          this.style.backgroundColor = ""
        }
      }
    })
  })
})
