package com.secondproject.cooook.handler.recipe;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.dao.MenuDao;
import com.secondproject.cooook.dao.IngredientDao;
import com.secondproject.cooook.dao.RecipeDao;
import com.secondproject.cooook.model.Menu;
import com.secondproject.cooook.model.Ingredient;
import com.secondproject.cooook.model.Recipe;

import java.util.List;

public class RecipeInsertHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response)  {
        RecipeDao recipeDao = new RecipeDao();

        if ("GET".equalsIgnoreCase(request.getMethod())) {
            // 레시피 미등록 메뉴만 조회
            List<Menu> menuList = new MenuDao().selectMenusWithoutRecipe();
            // 전체 재료 조회
            List<Ingredient> ingList = new IngredientDao().selectAll();

            request.setAttribute("menuList", menuList);
            request.setAttribute("ingList", ingList);
            return "recipe/recipe_insert.jsp";
        }

        // POST: 입력값 파싱
        int menuId = Integer.parseInt(request.getParameter("menuId"));
        String[] ingredientIds = request.getParameterValues("ingredientId");
        String[] units         = request.getParameterValues("unit");
        String[] quantities    = request.getParameterValues("quantity");
        String[] descriptions  = request.getParameterValues("description");



        // 다중 등록
        for (int i = 0; i < ingredientIds.length; i++) {
            Recipe recipe = new Recipe();
            recipe.setMenuId(menuId);
            recipe.setCategoryId(Integer.parseInt(ingredientIds[i]));
            recipe.setUnit(units[i]);
            recipe.setQuantity(Double.parseDouble(quantities[i]));
            recipe.setDescription(descriptions[i]);
            recipeDao.insertRecipe(recipe);
        }
        // 등록 성공 시 리스트로 리다이렉트
        return "redirect:/recipe.do";
    }

    // GET 재사용 메서드
    private String processGet(HttpServletRequest request) throws Exception {
        List<Menu> menuList = new MenuDao().selectMenusWithoutRecipe();
        List<Ingredient> ingList = new IngredientDao().selectAll();
        request.setAttribute("menuList", menuList);
        request.setAttribute("ingList", ingList);
        return "recipe/recipe_insert.jsp";
    }
}