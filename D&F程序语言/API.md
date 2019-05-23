>__索引从0开始__  

>Skill
- `sq_GetSkillLevel(obj, skill_name);`  
    >获取技能等级
-   `obj.sq_GetIntData(SKILL, index)`
    >获取技能数据  

    
- `obj.sq_GetLevelData(index)`  
    >*index*对应技能升级数据索引  

    `sq_GetLevelData(obj, SKILL_ICE_SWORD, 2, skill_level);`
    >获取技能等级所对应的参数数据  



>GameBody
- `sq_SendCreatePassivePacket(index, #, x, y, #)`
    >创建Obj特效对象
