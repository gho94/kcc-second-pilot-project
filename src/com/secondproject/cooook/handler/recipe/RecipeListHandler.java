package com.secondproject.cooook.handler.recipe;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.dao.RecipeDao;
import com.secondproject.cooook.model.Recipe;
import java.util.List;

public class RecipeListHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) {
        RecipeDao dao = new RecipeDao();

        // 검색어 파라미터
        String menuNameParam = request.getParameter("menuName");
        List<Recipe> recipeList;

        if (menuNameParam != null && !menuNameParam.isBlank()) {
            // 메뉴명 포함 검색
            recipeList = dao.selectByMenuName(menuNameParam);
            request.setAttribute("searchMenuName", menuNameParam);
        } else {
            // 전체 조회
            recipeList = dao.selectAllRecipes();
        }

        // 뷰로 전달
        request.setAttribute("recipeList", recipeList);
        // JSP에서 입력값 유지용
        request.setAttribute("menuName", menuNameParam);

        // forward할 JSP (앞에 "/" 없음)
        return "recipe/recipe_list.jsp";
    }
}
