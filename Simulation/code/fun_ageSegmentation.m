function [ r ] = fun_ageSegmentation( age )
%输入年龄返回分段信息向量0~16  17~24  25~32 33~40 41~48 49~

if age<=16
    r=1;
elseif age<=24
    r=2;
elseif age<=32
    r=3;
elseif age<=40
	r=4;
elseif age<=48
    r=5;
else
    r=6;
end


end

