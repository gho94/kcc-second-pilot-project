package com.secondproject.cooook.handler.category;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import com.secondproject.cooook.common.LocaleUtil;
import com.secondproject.cooook.dao.CategoryDao;
import com.secondproject.cooook.handler.CommandHandler;
import com.secondproject.cooook.model.Category;

public class CategoryHandler implements CommandHandler {                
	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) {
        Locale locale = (Locale) request.getSession().getAttribute("locale");
		String localeStr = LocaleUtil.getLocale(locale);		
        CategoryDao dao = new CategoryDao(localeStr);
        List<Category> categories = dao.selectCategory();
        
        JSONArray jsonArray = new JSONArray();
        for (Category category : categories) {
            JSONObject node = new JSONObject();
            
            node.put("id", category.getCategoryId());
            node.put("text", category.getCategoryName());
            node.put("parent", category.getParentId() == null ? "#" : String.valueOf(category.getParentId()));
            jsonArray.put(node);
        }

        request.setAttribute("categoryTree", jsonArray.toString());
        return "category/category.jsp";
	}

}
