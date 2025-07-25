package com.secondproject.cooook.common;

import java.util.Map;

public class RoleFeatureCode {
    public static final String WORKER_MANAGE   = "WORKER_MANAGE";
    public static final String ROLE_MANAGE     = "ROLE_MANAGE";
    public static final String ORDER_MANAGE    = "ORDER_MANAGE";
    public static final String MATERIAL_MANAGE = "MATERIAL_MANAGE";
    public static final String CATEGORY_MANAGE = "CATEGORY_MANAGE";
    public static final String MENU_MANAGE = "MENU_MANAGE";
    public static final String MENU_CATEGORY_MANAGE = "MENU_CATEGORY_MANAGE";

    public static final Map<String, String> FEATURE_NAME_MAP = Map.of(
        WORKER_MANAGE,          "작업자 관리",
        ROLE_MANAGE,            "권한 관리",
        ORDER_MANAGE,           "주문 관리",
        MATERIAL_MANAGE,        "레시피 관리",
        CATEGORY_MANAGE,        "카테고리 관리",
        MENU_MANAGE,            "메뉴 관리",
        MENU_CATEGORY_MANAGE,   "메뉴 카테고리 관리"
    );

    public static final Map<Integer, String> menuIndexToFeature = Map.of(
    	    1, WORKER_MANAGE,
    	    2, ROLE_MANAGE,
    	    3, ORDER_MANAGE,
    	    4, MATERIAL_MANAGE,
    	    5, CATEGORY_MANAGE,
            6, MENU_MANAGE,
            7, MENU_CATEGORY_MANAGE
    );
}
