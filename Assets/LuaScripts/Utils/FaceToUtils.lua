---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by admin.
--- DateTime: 2020/4/17 16:59
---
local FaceToUtils = {}
function FaceToUtils.GetFaceTo4(fx, fy, tx, ty, dir)
    if (fx == tx and fy == ty) then
        return dir
    end
    local d = (ty - fy) / (tx - fx)
    if (fx <= tx) then
        if (d > 2.414213562373095) then
            return 2
        elseif (d > 0.41421356237309503) then
            return 2
        elseif (d > -0.41421356237309503) then
            return 1
        elseif (d > -2.414213562373095) then
            return 1
        else
            return 4
        end
    else
        if (d <= -2.414213562373095) then
            return 2
        elseif (d <= -0.41421356237309503) then
            return 3
        elseif (d <= 0.41421356237309503) then
            return 3
        elseif (d <= 2.414213562373095) then
            return 4
        else
            return 4
        end
    end
end

return FaceToUtils