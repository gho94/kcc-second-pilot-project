// 레시피를 메뉴별로 그룹화하는 헬퍼 함수
function groupRecipesByMenu(recipes) {
    const menuMap = new Map();
    
    recipes.forEach(recipe => {
        if (!menuMap.has(recipe.menuId)) {
            menuMap.set(recipe.menuId, {
                menuId: recipe.menuId,
                menuName: recipe.menuName,
                recipes: []
            });
        }
        menuMap.get(recipe.menuId).recipes.push(recipe);
    });
    
    return Array.from(menuMap.values());
}

function toggleRecipes(menuId) {
    const detailsDiv = document.getElementById(`recipes-${menuId}`);
    const icon = document.getElementById(`icon-${menuId}`);
    
    if (detailsDiv.style.display === 'none' || detailsDiv.style.display === '') {
        detailsDiv.style.display = 'block';
        icon.textContent = '▼';
    } else {
        detailsDiv.style.display = 'none';
        icon.textContent = '▶';
    }
}

document.addEventListener("DOMContentLoaded", () => {

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
