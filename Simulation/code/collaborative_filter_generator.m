%For Problem 2: solution method 2, using collaborative filtering tech 
%to get user's distance.
function collaborative_filter_generator()
 dataset_path='../dataset/';                                                                                      %load film info.
 load([dataset_path,'UserFeature.mat']);                                                                          %load film preference info. 
 [~,~,uuser]=fun_readFiles('../dataset/u.data','../dataset/u.item','../dataset/joblist.txt','../dataset/u.user'); %load user info.
 
 sim_map=zeros(size(uuser,1),size(uuser,1));
 for i=1:size(sim_map,1)
    for j=1:size(sim_map,2) 
       if (sim_map(i,j)==0 && (i~=j))
          sim_map(i,j)=calc_sim(i,j,uuser,UserAverScore); 
          sim_map(j,i)=sim_map(i,j);
       elseif (i==j)
           sim_map(i,j)=-inf;
       end
    end
 end
  save([dataset_path,'user_simlarity_map.mat'],'sim_map');
end

%calculate similarity.
function [sim]=calc_sim(uid1,uid2,uuser,UserAverScore)
  uas1=UserAverScore(uid1,:);uas2=UserAverScore(uid2,:);
  age1=uuser(uid1,2);age2=uuser(uid2,2);
  minAge=min(uuser(:,2)); maxAge=max(uuser(:,2));
  age1=(age1-minAge)/(maxAge-minAge); age2=(age2-minAge)/(maxAge-minAge);
  feat1=[uas1,age1];feat2=[uas2,age2];
  sim=Pearson(feat1,feat2);
end

%calculate pearson coefficent.
function coeff = Pearson(X , Y)  

nom = sum(X .* Y) - (sum(X) * sum(Y)) / length(X);  
denom = sqrt((sum(X .^2) - sum(X)^2 / length(X)) * (sum(Y .^2) - sum(Y)^2 / length(X)));  
coeff = nom / denom;  
  
end %end of pearson.