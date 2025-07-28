package com.secondproject.cooook.handler.recipe;

import java.util.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.dao.IngredientDao;
import com.secondproject.cooook.dao.RecipeDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Ingredient;
import com.secondproject.cooook.model.Recipe;

public class RecipeUpdateHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) {
        if ("GET".equalsIgnoreCase(request.getMethod())) {
            return handleGet(request);
        } else if ("POST".equalsIgnoreCase(request.getMethod())) {
            return handlePost(request);
        } else {
            request.setAttribute("error", "잘못된 요청 방식입니다.");
            return "/error.jsp";
        }
    }

    // 🔹 GET: 기존 레시피 + 전체 재료 조회
    private String handleGet(HttpServletRequest request) {
        try {
            int menuId = Integer.parseInt(request.getParameter("menuId"));

            RecipeDao recipeDao = new RecipeDao();
            IngredientDao ingredientDao = new IngredientDao();

            List<Recipe> recipeList = recipeDao.getRecipesByMenuId(menuId);
            List<Ingredient> allIngredients = ingredientDao.selectAll();

            request.setAttribute("menuId", menuId);
            request.setAttribute("recipeList", recipeList);
            request.setAttribute("allIngredients", allIngredients);
            System.out.println("d?" + allIngredients);

            // ─────────────────────────────────────────────
            // 2) recipeList 가 비어있지 않으면 menuName 추가 설정
            if (!recipeList.isEmpty()) {
                // 첫 번째 Recipe 객체에서 메뉴 이름 추출
                String menuName = recipeList.get(0).getMenuName();
                request.setAttribute("menuName", menuName);
            }
            // ─────────────────────────────────────────────
            return "/recipe/recipe_update.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "레시피 조회 중 오류 발생");
            return "/error.jsp";
        }
    }

 // ✅ RecipeUpdateHandler.java (핸들러 - 기존 VO 사용)
    private String handlePost(HttpServletRequest request) {
        try {
            request.setCharacterEncoding("UTF-8");

            int menuId = Integer.parseInt(request.getParameter("menuId"));
            String[] ingredientIds = request.getParameterValues("ingredientId");
            String[] quantities = request.getParameterValues("quantity");
            String[] descriptions = request.getParameterValues("description");
            String[] deleteIds = request.getParameterValues("delete");

            if (ingredientIds == null || quantities == null || descriptions == null) {
                throw new IllegalArgumentException("폼 데이터가 누락되었습니다.");
            }

            Set<String> deleteSet = deleteIds != null ? new HashSet<>(Arrays.asList(deleteIds)) : new HashSet<>();

            List<Recipe> recipes = new ArrayList<>();
            for (int i = 0; i < ingredientIds.length; i++) {
                if (deleteSet.contains(ingredientIds[i])) continue;

                Recipe recipe = new Recipe();
                recipe.setMenuId(menuId);
                recipe.setIngredientId(Integer.parseInt(ingredientIds[i]));
                recipe.setQuantity(Double.parseDouble(quantities[i]));
                recipe.setDescription(descriptions[i]);
                // unit은 DB에서 불러올 예정
                recipes.add(recipe);
            }

            RecipeDao recipeDao = new RecipeDao();
            recipeDao.updateRecipe(menuId, recipes);

            return "redirect:/recipe/list.do";
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "레시피 수정 중 오류 발생");
            return "/error.jsp";
        }
    }

}
