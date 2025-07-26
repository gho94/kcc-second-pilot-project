package com.secondproject.cooook.handler.recipe;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.dao.RecipeDao;

public class RecipeDeleteHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) {
        String idParam = request.getParameter("recipeId");
        if (idParam != null && !idParam.isBlank()) {
            int recipeId = Integer.parseInt(idParam);
            new RecipeDao().deleteRecipe(recipeId);
        }
        // 삭제 후 목록으로 리다이렉트
        return "redirect:/recipe/list.do";
    }
}