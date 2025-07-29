package com.secondproject.cooook.handler.recipe;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.secondproject.cooook.dao.RecipeDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Recipe;

public class RecipeListHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) {
        RecipeDao dao = new RecipeDao();

        List<Recipe> recipeList = dao.selectAllRecipes();

        // 뷰로 전달
        request.setAttribute("recipeList", recipeList);
        
		
        return "recipe/recipe.jsp";
    }
    
}
