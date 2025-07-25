package com.secondproject.cooook.model;

import lombok.Data;

@Data
public class Role {
    private int roleId;
    private String roleName;
    private String description;
    private String featureCodes;
    private String featureNames;
}
