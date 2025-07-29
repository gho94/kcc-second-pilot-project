package com.secondproject.cooook.handler.recipe;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.dao.RecipeDao;

public class RecipeDeleteHandler implements CommandHandler {
    private RecipeDao recipeDao = new RecipeDao();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) {
        // 1) menuId 파라미터 획득
        String menuIdParam = request.getParameter("menuId");
        if (menuIdParam != null && !menuIdParam.isBlank()) {
            int menuId = Integer.parseInt(menuIdParam);

            // 2) 해당 메뉴에 속한 모든 레시피 일괄 삭제
            int deletedCount = recipeDao.deleteRecipesByMenuId(menuId);
            System.out.println("메뉴 ID " + menuId + "의 레시피 " + deletedCount + "건 삭제 완료");
        }

        // 3) 삭제 후 레시피 목록으로 리다이렉트
        return "redirect:/recipe.do";
    }
}
